#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";


function doIt() {
	# rsync this directory to the home, excluding files
	rsync --exclude ".git/" --exclude ".DS_STore" --exclude "bootstrap.sh"\
		--exclude "README.md" --exclude "LICENSE" -avh --no-perms . ~;
	source ~/.bash_profile;

	# Check if vundle is installed. If not, install it.
	if ! [ -d ~/.vim/bundle ]; then
		echo '~/.vim/bundle not found. Making directory'
		mkdir ~/.vim/bundle;
	fi;
	if ! [ -d ~/.vim/bundle/Vundle.vim ]; then
		echo 'Vundle.vim not found. Cloning.'
		git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim;
	fi;

	# Make sure all plugins are installed
	vim +PluginInstall +qall;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	git pull origin master;
	doIt;
else
	read -p "Do you want to pull the latest remote changes? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		git pull origin master;
	fi;

	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
