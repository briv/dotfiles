" Source other files
" ------------------------------------------------------------
let s:tmpviminitdir=fnamemodify(expand($MYVIMRC), ':h').'/'
exec 'source' . s:tmpviminitdir.'plugins.vim'
exec 'source' . s:tmpviminitdir.'keys.vim'
exec 'source' . s:tmpviminitdir.'statusline.vim'


" General vim settings
" ------------------------------------------------------------
set nocompatible
set hidden                                         " allow unsaved buffers

set history=1000                                   " keep lots of command history

autocmd BufLeave,FocusLost * nested silent! wall   " save on focus lost
autocmd BufWritePre * :%s/\s\+$//e                 " remove trailing whitespace on save

syntax on                                          " syntax highlighting
filetype plugin indent on                          " load filetype specific indentation plugins

set nobackup                                       " do not keep backups after close
set nowritebackup                                  " do not keep a backup while working
let s:tmpdir=$HOME.'/.vim/tmp//'
let &directory=s:tmpdir                            " centralize .swp files

syntax enable                                      " enable color
set background=dark
colorscheme Tomorrow-Night                         " from https://github.com/chriskempson/tomorrow-theme

" Symbols for hidden characters
set listchars=tab:▸\ ,eol:¬,trail:·,nbsp:_

set number " Line numbers
set colorcolumn=80 " Visual ruler at 80 chars
set cursorline " Highlight current line

if !has('nvim')
	set encoding=utf-8  " The encoding displayed.
endif
set fileencoding=utf-8  " The encoding written to file.

" Open splits below and to the right by default
set splitbelow
set splitright

" Enable the use of the mouse in all modes
set mouse=a

" Do not show additional information about current autocomplete match
set completeopt-=preview

" Tags
" ------------------------------------------------------------
" Combine upward and downward search to find .git/tags.
" see :help file-searching
if has('path_extra')
	set tags+=**0/.git/tags;~
endif

" Default indentation
" ------------------------------------------------------------
set tabstop=2
set shiftwidth=2
set expandtab

" File specific indentation
" ------------------------------------------------------------
" Abbreviations are ts sts sw
autocmd Filetype scala,sbt.scala setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype ruby setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype sh,zsh setlocal expandtab tabstop=4 shiftwidth=4
autocmd Filetype html,eruby setlocal expandtab tabstop=4 shiftwidth=4 sts=4
autocmd Filetype javascript,typescript setlocal expandtab tabstop=2 shiftwidth=2 sts=2

" Search
" ------------------------------------------------------------
set ignorecase   " ignore case when searching
set smartcase    " take case into account if pattern contains uppercase
