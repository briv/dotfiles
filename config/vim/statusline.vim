" Always show status line
set laststatus=2
" Clear the statusline for when vimrc is reloaded
set statusline=
" Add file type
set statusline+=%.99f\ -\ \%y
" Add modified status
set statusline+=%m

" Display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

" Switch to the right side
set statusline+=%=
" Column, line and percentage
set statusline+=\Line:\ %-4l
set statusline+=\ Column:\ %-3v
set statusline+=\ %P

set statusline+=\ [%{strlen(&fenc)?&fenc:'none'}, " file encoding
set statusline+=%{&ff}] " file format
