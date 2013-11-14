" Open reference documents. This could almost be a plugin.
function! OpenReference()
    execute "tabnew"
    execute "cd ".g:Reference_File_Location
    execute "CtrlP"
endfunction
nmap <Leader>re :call OpenReference()<CR>

" Reformat paragraph.
nmap <Leader>rp vipJVgq

" Toggle paste mode.
nmap <Leader>, :set paste!<CR>

" Edit the alternate file (the same as ctrl-6).
nmap <Leader>. :e #<CR>

nmap <Space> :set hlsearch!<CR>
"nmap <Return> :silent! normal za<CR>

" Y yanks to the end of the line, as you would expect it to.
nmap Y y$

" Leader-s toggles syntastic, which displays errors for 'interpretable' files.
nmap <Leader>s :SyntasticToggleMode<CR>

" Delete trailing whitespace.
nnoremap S :call StripTrailingWhitespace()<CR>

" Create surrounding HTML tags out of the word near the cursor.
imap <C-a> <ESC>viwc<"></"><ESC>cit

" Set Shift-Left and Shift-Right to scroll left and right. Helpful while using
" the diff function.
nmap <S-Left> 5zh
nmap <S-Right> 5zl

" Map the movement command that cycles through diff changes to also center the
" line vertically in the window when it is arrived at. It's convenient.
nmap ]c ]cz.
nmap [c [cz.

" Indent or 'outdent' the last 'put' block with Ctrl-H (outdent) and Ctrl-L
" (indent). This way you can put a block and immediately move it to the
" correct indention. This is probably my favorite mapping.
nmap <C-h> '[<lt>']
nmap <C-l> '[>']

" Ctrl-E while in insert mode moves the cursor to the end of the line, a la
" OS X and other UN*X interfaces (e.g. bash).
imap <C-e> <Esc>A

" Allow the up and down arrows to move between LOGICAL lines of text on the
" screen, even if they are wrapped portions of the same LITERAL line of text.
" Works in any mode.
map <Up> gk
map <Down> gj

" Mappings for easier split window navigation:
" Ctrl-w followed by u and d for up and down moves you to the next window
" either up or down and maximizes it all at once (accordion mode).
nmap <C-w>u <C-w><Up><C-w>_
nmap <C-w>d <C-w><Down><C-w>_

" ----------------------------- Omnicompletion --------------------------------
" Remap the omnicompletion commands because all the <C-x> shit is annoying.

" Words
inoremap <Leader><Tab> <C-x><C-o>

" Filenames
inoremap <Leader>: <C-x><C-f>

" Lines
inoremap <Leader>= <C-x><C-l>

" --------------------------------- Ctrl-P ------------------------------------
nmap <C-p> :CtrlP<CR>
nmap <Leader>b :CtrlPBuffer<CR>

" --------------------------- Visual Mode Mappings ----------------------------
" In visual mode, D will Duplicate the selected lines after the visual block.
vmap D y'>p']

" Allow * and # to work the way you would expect when some text is selected.
" These use the z register for now until I can find the more elegant solution,
" which I know exists.
vmap * "zy/<C-r>z<CR>
vmap # "zy?<C-r>z<CR>

" vim: set et ts=4 sw=4 :
