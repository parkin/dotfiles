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

" Optimize for fast terminal connections
set ttyfast

" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif

" Don't create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Highlight current line
set cursorline

" Highlight searches
set hlsearch

" Ignore case of searches
set ignorecase

" Enable mouse in all modes
set mouse=a

" Show the cursor position
set ruler

" Start scrolling three lines before the horizontal window border
set scrolloff=3

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

" Open files at same position they were left at.
if has("autocmd")
	au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
				\| exe "normal! g'\"" | endif
endif
