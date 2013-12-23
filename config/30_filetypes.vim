" --------------------------- Filetype overrides ---------------------------
autocmd BufRead,BufNewFile */source/*.html set filetype=liquid
autocmd BufRead,BufNewFile *.txt set filetype=text
autocmd BufRead,BufNewFile *.wiki set filetype=wiki
autocmd BufRead,BufNewFile */_posts/* set filetype=octopress
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile *.markdown set filetype=markdown

" ----------------- Version-specific filetype preferences -----------------
if v:version > 702
    autocmd FileType php set colorcolumn=120
    autocmd FileType markdown set colorcolumn=80
endif

" vim: set et ts=4 sw=4 :
