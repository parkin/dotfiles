set nocompatible	"Use Vim settings, rather than Vi settings
filetype off		"required!

" Use Vundle as preferred plugin manager
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/vundle'

"******** Markdown
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
" Highlight YAML frontmatter used by Jekyll
let g:vim_markdown_frontmatter=1

"******* Fugitive for Git inside Vim
Plugin 'tpope/vim-fugitive'

"******* NERD tree explorer plugin
Plugin 'scrooloose/nerdtree'

"****** ctrlp.vim fuzzy file, buffer, mru, tag, etc finder
Plugin 'kien/ctrlp.vim'

"****** vim-gitgutter for git diff in the gutter
Plugin 'airblade/vim-gitgutter'

" *********************************
" All of your Plugins must be added before the following line
call vundle#end()		"required
filetype plugin indent on	"required

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Enable line numbers
set number

