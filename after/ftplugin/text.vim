" Vim filetype plugin file
" Language: Test case file
" Maintainer: Aaron Bieber <a.bieber@jobtarget.com>
" Last Change: 17 December 2008

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
	finish
endif

setlocal textwidth=75
setlocal formatoptions=tqnaw
"setlocal expandtab
let b:SuperTabDisable = 1

setlocal formatlistpat=^\\s*[0-9ivx*]\\+[\\]:.)}\\t\ ]\\s*

" Attempt to indent/detent bulleted lists when asterisks are used.
nnoremap <C-S-Left> ?^\t\+\*<CR>V/^\t\+\*/-1<CR><
nnoremap <C-S-Right> ?^\t\+\*<CR>V/^\t\+\*/-1<CR>>

" Don't load another plugin for this buffer
let b:did_ftplugin = 1
