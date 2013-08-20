"____Filetype preferences____
autocmd BufRead,BufNewFile *.txt setfiletype text
autocmd BufRead,BufNewFile *.wiki setfiletype wiki
autocmd BufRead,BufNewFile *.md setfiletype octopress
autocmd BufRead,BufNewFile *.markdown setfiletype octopress

" When entering a buffer, change the local working directory to the location 
" of the file. This is actually really handy, most of the time.
autocmd BufEnter * lcd %:p:h

" Set specific settings for specific filetypes.
autocmd FileType css set smartindent
autocmd FileType markdown set tw=78 expandtab ts=4 sw=4 spell nocindent autoindent
autocmd FileType octopress set tw=78 expandtab ts=4 sw=4 spell nocindent autoindent
autocmd FileType haml set expandtab ts=2 sw=2
autocmd FileType perl set smartindent
autocmd FileType javascript set expandtab ts=2 sw=2 fo=nwcroql tw=120
autocmd FileType javascript inoremap {<cr> {<cr>}<c-o>O
autocmd FileType javascript inoremap [<cr> [<cr>]<c-o>O
autocmd FileType javascript inoremap (<cr> (<cr>)<c-o>O
autocmd FileType python set expandtab ts=2 sw=2
autocmd FileType ruby set ts=2 sw=2 autoindent expandtab cinkeys-=0# nosmartindent
autocmd FileType vim set ts=4 sw=4
autocmd FileType wiki set tw=0 fo=tqnw
autocmd FileType xhtml inoremap <S-CR> <br />
autocmd FileType yaml set ts=2 sw=2 expandtab

autocmd FileType php set expandtab ts=2 sw=2 tw=120 cc=+1 previewheight=1 cindent
autocmd FileType php inoremap {<cr> {<cr>}<c-o>O
autocmd FileType php inoremap [<cr> [<cr>]<c-o>O
autocmd FileType php inoremap (<cr> (<cr>)<c-o>O

" Close the preview window when leaving insert mode.
autocmd InsertLeave *.php if pumvisible() == 0|pclose|endif
autocmd BufWritePre *.php :call StripTrailingWhitespace()

"____Version-specific filetype preferences____
if v:version > 702
    autocmd FileType php set colorcolumn=120
    autocmd FileType markdown set colorcolumn=80
endif

" vim: set et ts=4 sw=4 :
