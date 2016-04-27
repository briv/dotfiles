" vim-plug Plugins
if has('nvim')
  call plug#begin('~/.config/nvim/plugged')
else
  call plug#begin('~/.vim/plugged')
endif
Plug 'tpope/vim-sensible'
"  Plug 'tpope/vim-vinegar'
Plug 'sjl/vitality.vim'
Plug 'junegunn/fzf.vim'
Plug 'tomtom/tcomment_vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'benmills/vimux'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"  Plug 'wellle/targets.vim'
" Allow direct Ctrl-<key> mappings for fluid navigation between tmux & neovim
" Plug 'christoomey/vim-tmux-navigator'

" Language-specific plugins
 Plug 'tpope/vim-rails'
 Plug 'leafgarland/typescript-vim'
 Plug 'derekwyatt/vim-scala'
 Plug 'LnL7/vim-nix'
 Plug 'idris-hackers/idris-vim'
 call plug#end() " add plugins to &runtimepath

" Plugin settings
" ------------------------------------------------------------
let g:vitality_fix_cursor = 0     " configure sjl/vitality.vim to not fix cursor
let &rtp = &rtp . ',' . '~/.nix-profile/share/vim-plugins/fzf' " use fzf plugin from nixpkgs
let g:fzf_buffers_jump = 1 " Jump to the existing window if possible
" let g:deoplete#enable_at_startup = 3
let g:deoplete#max_list = 10

" See keys.vim for vim-tmux-navigator
" let g:tmux_navigator_save_on_switch = 1
" let g:tmux_navigator_disable_when_zoomed = 1 " Disable tmux navigator when
                                               " zooming the Vim pane

" TODO LATER
 """"""""""
 " goyo / limelight
 " airline
 " lightline (plus léger)
 " myusuf3/numbers.vim
 " Yggdroot/indentiline
 " killphi/vim.legend
 " geoffharcourt/vim-matchit
 " vim-anzu
 "" tpope :
 " vim-repeat
 " vim-surround
 " speeddating
 " vim-fugitive
 " undotree
 "
 " vim-tmux-navigator
 " junegunn/gv.vim
 " gitgutter
 " alvan/vim-closetag
 " Raimondi/delimitMate
 " mattn/emet.vim
 " html5 / css3 plugins
 """"""""""
