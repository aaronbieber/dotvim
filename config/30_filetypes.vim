" --------------------------- Filetype overrides ---------------------------
autocmd BufRead,BufNewFile *.txt setfiletype text
autocmd BufRead,BufNewFile *.wiki setfiletype wiki
autocmd BufRead,BufNewFile */_posts/* set filetype=octopress
autocmd BufRead,BufNewFile *.md setfiletype markdown
autocmd BufRead,BufNewFile *.markdown setfiletype markdown

" ----------------- Version-specific filetype preferences -----------------
if v:version > 702
    autocmd FileType php set colorcolumn=120
    autocmd FileType markdown set colorcolumn=80
endif

" vim: set et ts=4 sw=4 :
