-- archive
if true then
  return {}
end

-- add an AI group to which-key
local wk = require("which-key")
wk.add({
  { "<leader>a", group = "+AI" }, -- group
})

local adapter_default = "anthropic2"
if vim.fn.hostname() == "wsl-nixos" then
  adapter_default = "wca"
end

-- my usual config
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    strategies = {
      chat = {
        adapter = adapter_default,
      },
      inline = {
        adapter = adapter_default,
      },
      cmd = {
        adapter = adapter_default,
      },
    },
    opts = {
      log_level = "DEBUG", -- For development
    },
    adapters = {
      anthropic2 = function()
        return require("codecompanion.adapters").extend("anthropic", {
          name = "anthropic2", -- differentiate my extensions
          schema = {
            max_tokens = {
              default = 30000,
            },
          },
        })
      end,
      wca = function()
        -- local client = require("codecompanion.http")
        local openai = require("codecompanion.adapters.openai")
        local log = require("codecompanion.utils.log")
        local curl = require("plenary.curl")

        ---@alias WCABearerToken {access_token: string, expiration: number}|nil
        local _iam_token

        ---@return WCABearerToken
        local function authorize_token()
          if _iam_token and _iam_token.expiration > os.time() then
            log:trace("Reusing IAM token")
            return _iam_token
          end

          log:debug("Requesting new IAM token")

          local wca_api_key = os.getenv("WCA_API_KEY")

          local request = curl.post("https://iam.cloud.ibm.com/identity/token", {
            headers = { ["Content-Type"] = "application/x-www-form-urlencoded" },
            body = "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=" .. wca_api_key,
            on_error = function(err)
              log:error("WCA Adapter: Error requesting IAM token, %s", err)
            end,
          })

          _iam_token = vim.json.decode(request.body)
          return _iam_token
        end

        ---@class WCA.Adapter: CodeCompanion.Adapter
        return require("codecompanion.adapters").new({
          name = "wca",
          formatted_name = "Watson Code Assistant",
          roles = {
            llm = "assistant",
            user = "user",
          },
          opts = {
            stream = false,
            -- TODO: streamline this request and handler logic (for now, just copied from main CodeCompanion)
            request = function(client, payload, actions, opts)
              local config = require("codecompanion.config")
              local util = require("codecompanion.utils")
              local Path = require("plenary.path")

              opts = opts or {}
              local cb = log:wrap_cb(actions.callback, "Response error: %s") --[[@type function]]

              -- Make a copy of the adapter to ensure that we replace variables in every request
              local adapter = vim.deepcopy(client.adapter)

              local handlers = adapter.handlers

              if handlers and handlers.setup then
                local ok = handlers.setup(adapter)
                if not ok then
                  return log:error("Failed to setup adapter")
                end
              end

              adapter:get_env_vars()

              local body = client.opts.encode(
                vim.tbl_extend(
                  "keep",
                  handlers.form_parameters
                      and handlers.form_parameters(adapter, adapter:set_env_vars(adapter.parameters), payload.messages)
                    or {},
                  handlers.form_messages and handlers.form_messages(adapter, payload.messages) or {},
                  handlers.form_tools and handlers.form_tools(adapter, payload.tools) or {},
                  adapter.body and adapter.body or {},
                  handlers.set_body and handlers.set_body(adapter, payload) or {}
                )
              )

              local body_file = Path.new(vim.fn.tempname() .. ".json")
              body_file:write(vim.split(body, "\n"), "w")

              log:info("Request body file: %s", body_file.filename)

              ---@type table|nil
              local form = handlers.set_form and handlers.set_form(adapter, payload) or nil

              local form_files = {} -- keep track of files so they can be deleted
              local form_filenames = {} -- final { form_name = "<filename" } table for curl
              -- add temporary files for each form entry
              if form then
                for name, content in pairs(form) do
                  -- first check that content isn't already referencing a file with leading "@" or "<" character
                  if content:sub(1, 1) ~= "@" and content:sub(1, 1) ~= "<" then
                    -- make a temporary file
                    local form_file = Path.new(vim.fn.tempname())
                    form_file:write(vim.split(content, "\n"), "w")
                    form_files[name] = form_file
                    log:info("Request form: %s: %s", name, form_file.filename)

                    -- add the entry for curl
                    form_filenames[name] = "<" .. form_file.filename
                  else
                    form_filenames[name] = content
                  end
                end
              end

              local function cleanup(status)
                if vim.tbl_contains({ "ERROR", "INFO" }, config.opts.log_level) and status ~= "error" then
                  body_file:rm()

                  -- cleanup the form temp files
                  for _, form_file in pairs(form_files) do
                    form_file:rm()
                  end
                end
              end

              local raw = {
                "--retry",
                "3",
                "--retry-delay",
                "1",
                "--keepalive-time",
                "60",
                "--connect-timeout",
                "10",
              }

              if adapter.opts and adapter.opts.stream then
                table.insert(raw, "--tcp-nodelay")
                table.insert(raw, "--no-buffer")
              end

              if adapter.raw then
                vim.list_extend(raw, adapter:set_env_vars(adapter.raw))
              end

              local request_opts = {
                url = adapter:set_env_vars(adapter.url),
                headers = adapter:set_env_vars(adapter.headers),
                insecure = config.adapters.opts.allow_insecure,
                proxy = config.adapters.opts.proxy,
                raw = raw,
                body = body_file.filename or "",
                form = form and form_filenames or nil,
                -- This is called when the request is finished. It will only ever be called
                -- once, even if the endpoint is streaming.
                callback = function(data)
                  vim.schedule(function()
                    if (not adapter.opts.stream) and data and data ~= "" then
                      log:trace("Output data:\n%s", data)
                      cb(nil, data, adapter)
                    end
                    if handlers and handlers.on_exit then
                      handlers.on_exit(adapter, data)
                    end
                    if handlers and handlers.teardown then
                      handlers.teardown(adapter)
                    end
                    if actions.done and type(actions.done) == "function" then
                      actions.done()
                    end

                    opts.status = "success"
                    if data.status >= 400 then
                      opts.status = "error"
                    end

                    if not opts.silent then
                      util.fire("RequestFinished", opts)
                    end
                    cleanup(opts.status)
                    if client.user_args.event then
                      if not opts.silent then
                        util.fire("RequestFinished" .. (client.user_args.event or ""), opts)
                      end
                    end
                  end)
                end,
                on_error = function(err)
                  vim.schedule(function()
                    actions.callback(err, nil)
                    if not opts.silent then
                      util.fire("RequestFinished", opts)
                    end
                  end)
                end,
              }

              -- allow the adapter to modify the http request before it is sent
              request_opts = handlers.modify_request_opts
                  and handlers.modify_request_opts(client, payload, request_opts)
                or request_opts

              if adapter.opts and adapter.opts.stream then
                local has_started_steaming = false

                -- Turn off plenary's default compression
                request_opts["compressed"] = adapter.opts.compress or false

                -- This will be called multiple times until the stream is finished
                request_opts["stream"] = client.opts.schedule(function(_, data)
                  if data and data ~= "" then
                    log:trace("Output data:\n%s", data)
                  end
                  if not has_started_steaming then
                    has_started_steaming = true
                    if not opts.silent then
                      util.fire("RequestStreaming", opts)
                    end
                  end
                  cb(nil, data, adapter)
                end)
              end

              local request = "post"
              if adapter.opts and adapter.opts.method then
                request = adapter.opts.method:lower()
              end

              local job = client.opts[request](request_opts)

              -- Data to be sent via the request
              opts.id = math.random(10000000)
              opts.adapter = {
                name = adapter.name,
                formatted_name = adapter.formatted_name,
                model = type(adapter.schema.model.default) == "function" and adapter.schema.model.default()
                  or adapter.schema.model.default
                  or "",
              }

              if not opts.silent then
                util.fire("RequestStarted", opts)
              end

              if job and job.args then
                log:debug("Request:\n%s", job.args)
              end
              if client.user_args.event then
                if not opts.silent then
                  util.fire("RequestStarted" .. (client.user_args.event or ""), opts)
                end
              end

              return job
            end,
          },
          features = {
            text = true,
            tokens = true,
            vision = false,
          },
          url = "https://api.dataplatform.cloud.ibm.com/v2/wca/core/chat/text/generation",
          env = {
            api_key = function()
              return authorize_token().access_token
            end,
          },
          headers = {
            Authorization = "Bearer ${api_key}",
            ["content-type"] = "multipart/form-data",
          },
          handlers = {
            setup = function(self)
              if self.opts and self.opts.stream then
                self.parameters.stream = true
              end
              return true
            end,

            --- Use the OpenAI adapter for the bulk of the work
            tokens = function(self, data)
              return openai.handlers.tokens(self, data)
            end,
            form_parameters = function(self, params, messages)
              return openai.handlers.form_parameters(self, params, messages)
            end,
            form_messages = function(self, messages)
              messages = vim
                .iter(messages)
                :map(function(m)
                  local model = self.schema.model.default
                  if type(model) == "function" then
                    model = model(self)
                  end
                  if vim.startswith(model, "o1") and m.role == "system" then
                    m.role = self.roles.user
                  end

                  -- Ensure tool_calls are clean
                  if m.tool_calls then
                    m.tool_calls = vim
                      .iter(m.tool_calls)
                      :map(function(tool_call)
                        return {
                          id = tool_call.id,
                          ["function"] = tool_call["function"],
                          type = tool_call.type,
                        }
                      end)
                      :totable()
                  end

                  return {
                    role = m.role:upper(), -- ensure upper case for WCA
                    content = m.content,
                    tool_calls = m.tool_calls,
                    tool_call_id = m.tool_call_id,
                  }
                end)
                :totable()

              return { messages = messages }
            end,
            modify_request_opts = function(self, payload, request_opts)
              -- for now this method requires you implement it manually in the codecompanion.adapters.init.lua and codecompanion.http
              request_opts.body = nil
              return request_opts
            end,
            set_form = function(self, payload)
              -- for now this method requires you implement it manually in the codecompanion.adapters.init.lua and codecompanion.http
              local output = {
                message = vim.base64.encode(
                  vim.json.encode({ message_payload = openai.handlers.form_messages(self, payload.messages) })
                ),
              }
              return output
            end,
            ---Output the data from the API ready for insertion into the chat buffer
            ---@param self CodeCompanion.Adapter
            ---@param data table The streamed JSON data from the API, also formatted by the format_data handler
            ---@return table|nil [status: string, output: table]
            chat_output = function(self, data)
              log:debug("chat_output: " .. vim.json.encode(data))

              if not data or data == "" then
                log:error("No data passed to chat_output")
                return nil
              end

              -- Handle only structured response
              local data_mod = type(data) == "table" and data.body
              local ok, json = pcall(vim.json.decode, data_mod, { luanil = { object = true } })

              if not ok or not json.response then
                log:error("error with json decode pcall")
                return nil
              end

              local output = {
                role = json.response.message.role:lower() or "",
                content = json.response.message.content:lower() or "",
              }

              self.schema.model.default = json.model

              return {
                status = "success",
                output = output,
              }
            end,
            inline_output = function(self, data, context)
              return openai.handlers.inline_output(self, data, context)
            end,
            on_exit = function(self, data)
              return openai.handlers.on_exit(self, data)
            end,
          },
          schema = {
            ---@type CodeCompanion.Schema
            model = {
              order = 1,
              mapping = "parameters",
              type = "enum",
              desc = "ID of the model to use. See the model endpoint compatibility table for details on which models work with the Chat API.",
              default = "wca?",
              choices = {
                "wca?",
              },
            },
          },
        })
      end,
    },
  },
  keys = {
    {
      "<leader>at",
      function()
        require("codecompanion").toggle()
      end,
      desc = "Toggle the AI chat window.",
    },
  },
}
