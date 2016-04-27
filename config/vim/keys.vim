" Alternatives to exit insert mode
" inoremap <esc> <nop>
" inoremap jk <Esc>
" inoremap kj <Esc>
" Map the leader key to SPACE
let mapleader="\<SPACE>"

" Switch between next/previous buffers
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprevious<CR>

" Navigate window splits
" Without vim-tmux-navigator
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" Shortcut to toggle invisible characters
nnoremap <leader>, :set list!<CR>
" Shortcut to toggle search highlighting
nnoremap <leader>s :set hlsearch! hlsearch?<CR>

" Shortcut to create a vertical split
nnoremap <leader>v <C-w>v<C-w>l
" Shortcut to create a horizontal split
nnoremap <leader>- <C-w>s<C-w>j
" Shortcut to delete buffer but keep split
nnoremap <leader>\ :bp\|bd #<CR>

" Shortcut for fzf search of files, using GitFiles when relevant
function! AdaptiveVersionControlOrNotFiles()
  silent !git rev-parse
  if !v:shell_error
    :GitFiles
  else
    :Files
  endif
endfunction
nnoremap <leader>f :call AdaptiveVersionControlOrNotFiles()<CR>

" Shortcut for fzf search of open buffers
nnoremap <leader>b :Buffers<CR>

" Shortcut for fzf search of 'grep-like' search results
command! -bang -nargs=* Find
  \ call fzf#vim#grep('rg
  \ --column --line-number --no-heading --smart-case
  \ --fixed-strings '.shellescape(<q-args>), 1, <bang>0)
nnoremap <leader>g :Find<Space> <C-R><C-W><CR>
nnoremap <leader>G :Find<Space>

let g:tcomment_opleader1 = '<leader>c' " remap shortcut for commenting with tomtom/tcomment_vim

" " Use either: currently selected text or paragraph under cursor and send it to
" " tmux runner pane (creating it if necessary)
function! TmuxSendTextOrCurrentText(...)
  if empty($TMUX)
    return
  endif

  if !exists("g:VimuxRunnerIndex") || _VimuxHasRunner(g:VimuxRunnerIndex) == -1
    call VimuxOpenRunner()
  endif

  let l:text = ""
  if exists("a:1")
    let l:text = a:1
  else
    " use paragraph under curor position as text to send to tmux
    let l:winview = winsaveview()
    let l:reg = @v
    normal! vip"vy
    let l:text = @v
    let @v = l:reg
    call winrestview(l:winview)
  endif

  let l:clearscrollback = 0
  if exists("a:2")
    let l:clearscrollback = a:2
  endif

  if match(l:text, "^\s*\n*$") != 0
    let l:chomped = substitute(l:text, '\n\+$', '', '')
    if l:clearscrollback
      call _VimuxTmux("clear-history -t ".g:VimuxRunnerIndex)
    endif
    call VimuxRunCommand(l:chomped)
  endif
endfunction

" Run last command issued from above or display message if no recent command
" exists
function! TmuxSaveAndResendLastText()
  if empty($TMUX)
    return
  endif

  if exists("g:VimuxLastCommand")
    " save buffer if needed
    if filereadable(bufname("%"))
      write
    endif
    " clear tmux scroll history
    let l:clearscrollback = 1
    " set Vimux Reset sequence to a good default for shells
    let g:VimuxResetSequence = "q C-u clear Enter"
    call TmuxSendTextOrCurrentText(g:VimuxLastCommand, l:clearscrollback)
  else
    echo "No previous command to resend to tmux."
  endif
endfunction

function! TmuxCloseVimuxRunnerPane()
  if empty($TMUX)
    return
  endif
  call VimuxCloseRunner()
endfunction

nnoremap <leader>t :call TmuxSendTextOrCurrentText()<CR>
nnoremap <leader>r :call TmuxSaveAndResendLastText()<CR>
nnoremap <leader>q :call TmuxCloseVimuxRunnerPane()<CR>

" One less key to go in command mode
nnoremap ; :
" Use \ instead of ; (overriden above) to look for the next character occurence
nnoremap \ ;

" Shortcut to jump to definition
nnoremap <leader>] <C-]>
" Shortcut to climb back up the definition tree
nnoremap <leader>[ <C-t>

if has('nvim')
" System clipboard shortcuts
	nnoremap <leader>y "+y
	vnoremap <leader>y "+y
	" Escape is already used within zsh shell for vim mode
	tnoremap <C-t> <C-\><C-n>
endif

" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
