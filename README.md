dotfiles
========

My personal dotfiles

##Installation

Clone the repository wherever you want.
The bootstrap script will pull the latest version and copy the files to your home folder.

```bash
git clone https://github.com/parkin/dotfiles.git && cd dotfiles && source bootstrap.sh
```

To update, cd into your local `dotfiles` repository and then:

```bash
source bootstrap.sh
```

Alternatively, to update and avoid the confirmation prompt:

```bash
set -- -f; source bootstrap.sh
```

###Specify the `$PATH`

If `~/.path` exists, it will be sourced along with the other files, before any feature testing takes place.

Here's an example `~/.path` file that adds `~/utils` to the `$PATH`:

```bash
export PATH="$HOME/utils:$PATH"
```

Note that `~/bin` is already added to the `$PATH` in [.exports](.exports).

###Adding Custom Commands

If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository.


##Thanks to

* [mathiasbynens](https://github.com/mathiasbynens) for the [amazing dotfiles project](https://github.com/mathiasbynens/dotfiles).

