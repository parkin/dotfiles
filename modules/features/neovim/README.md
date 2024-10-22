# Neovim config

I started from [LazyVim](https://github.com/LazyVim/LazyVim), then made a lot of changes due to both `nix` and my own personal preferences.

## Jupyter experience

I'm using [molten-nvim](https://github.com/benlubas/molten-nvim) and [NotebookNavigator.nvim](https://github.com/GCBallesteros/NotebookNavigator.nvim) for a Jupyter-like experience.

I have 3 windows open:

1. neovim
2. [qtconsole](https://github.com/jupyter/qtconsole) window open to display images and other repl output.
3. browser to display [plotly](https://github.com/plotly/plotly.py) interactive plots

### Starting the kernel

See [molten's venv instructions](https://github.com/benlubas/molten-nvim/blob/main/docs/Virtual-Environments.md).

You can make a new kernel available to your user

```shell
pixi shell # or however you like to activate your python venv
pip install ipykernel # if you don't have this already in your venv
python -m ipykernel install --user --name project_name
```

Then, the kernel `project_name` will be available to molten.

In neovim, you can use the following command to start the kernel:

```vim
:MoltenInit project_name
```

### Images

I haven't yet tried to display images with molten.
So for now, after starting molten, you can connect to the same kernel with [qtconsole](https://github.com/jupyter/qtconsole) by running the following in a different terminal:

```shell
jupyter qtconsole --existing --ConsoleWidget.include_other_output=True
```

Note you should run this in the python env corresponding to the kernel.

This allows you to view images (eg matplotlib plots).

### Plotly

Unfortunately, [qtconsole](https://github.com/jupyter/qtconsole) doesn't display interactive [plotly](https://github.com/plotly/plotly.py) plots.

So, in my wsl's [home.nix](../../../hosts/wsl/home.nix), I added the following environment variables so that plotly interactive plots open in the browser.

```nix
programs.bash.sessionVariables = {
  # Set extra variables for Plotly to render in the Windows browser.
  # see https://plotly.com/python/renderers/
  BROWSER = ''/mnt/c/Program Files/Mozilla Firefox/firefox.exe'';
  PLOTLY_RENDERER = "browser";
};

```
