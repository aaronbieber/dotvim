"____Filetype preferences____
" Set some other options for ColdFusion files.
autocmd FileType cf set formatoptions=croql textwidth=180
autocmd FileType cf nnoremap p ]p
autocmd FileType cf nnoremap P ]P
autocmd BufRead,BufNewFile *.txt setfiletype text
autocmd BufRead,BufNewFile *.wiki setfiletype wiki
autocmd BufEnter * lcd %:p:h
autocmd FileType markdown set tw=78

" This will cause VIM to automatically enter 'binary' mode when writing files
" that are in /custom_tags/ so that they will be saved without a terminating
" linebreak (at the end of the file). :h binary for more information.
autocmd BufWritePre */custom_tags/*.cfm	setl binary noeol
autocmd BufWritePost */custom_tags/*.cfm	setl nobinary eol

autocmd FileType cf inoremap <S-CR> <br />
autocmd FileType cf set smartindent
autocmd FileType css set smartindent
autocmd FileType javascript set smartindent noautoindent nocindent
autocmd FileType markdown set expandtab ts=4 sw=4
autocmd FileType perl set smartindent
autocmd FileType php set expandtab ts=4 sw=4 tw=120 previewheight=1 cindent
autocmd FileType php inoremap {<cr> {<cr>}<c-o>O
autocmd FileType php inoremap [<cr> [<cr>]<c-o>O
autocmd FileType php inoremap (<cr> (<cr>)<c-o>O
autocmd FileType javascript inoremap {<cr> {<cr>}<c-o>O
autocmd FileType javascript inoremap [<cr> [<cr>]<c-o>O
autocmd FileType javascript inoremap (<cr> (<cr>)<c-o>O
autocmd FileType python set expandtab ts=2 sw=2
autocmd FileType ruby set ts=2 sw=2 autoindent expandtab cinkeys-=0# nosmartindent
autocmd FileType vim set ts=4 sw=4
autocmd FileType wiki set tw=0 fo=tqnw
autocmd FileType xhtml inoremap <S-CR> <br />
autocmd FileType yaml set ts=2 sw=2 expandtab

" Close the preview window when leaving insert mode.
autocmd InsertLeave *.php if pumvisible() == 0|pclose|endif

"____Version-specific filetype preferences____
if v:version > 702
	autocmd FileType php set colorcolumn=80
	autocmd FileType markdown set colorcolumn=80
endif
