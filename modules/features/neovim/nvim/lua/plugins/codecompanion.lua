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
  -- "olimorris/codecompanion.nvim",
  "parkin/codecompanion.nvim",
  branch = "request_override",
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
        local client = require("codecompanion.http")
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
