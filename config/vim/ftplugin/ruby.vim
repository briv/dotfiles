" RuboCop mapping to automatically correct offenses. The current position is
" first marked and then jumped back to.
nnoremap <leader>ra mS:RuboCop -a<CR>:q<CR><C-w>p`S:delm S<CR>
