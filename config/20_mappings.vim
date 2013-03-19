"____Helpful mappings____

map <leader>r :registers<CR>
nmap <Leader>cc :let &colorcolumn=virtcol('.')<CR>

" Y yanks to the end of the line
nmap Y y$

" Delete trailing whitespace.
nnoremap S :silent! %s/[\r \t]\+$//<CR>

" shortcuts for copying to/pasting from the clipboard
nmap <leader>y "*y
vmap <leader>y "*y
nmap <leader>Y "*yy
nmap <leader>p "*p
nmap <leader>P "*P

" Control-backspace deletes a whole word backwards in insert mode
imap <C-BS> <C-W>

" Create surrounding HTML tags out of the word near the cursor.
imap <C-A> <ESC>viwc<"></"><ESC>cit

" Attempt to maximize the window in Windows only:
if has('gui') && has('win32')
    nmap <C-X> :simalt ~x<CR>
endif

" Make search movements center the result in the window.
" nnoremap n nzz
" nnoremap N Nzz

" This is still of very questionable utility.
imap jj <ESC>

" 'Maximize' a split with F6.
nmap <F6> <C-W>_

" Set up Ctrl-Left and Ctrl-Right to cycle through buffers (invisible
" windows). Helpful when you use the right click command 'open all in single
" Vim' to move through them. Use :buffers to view list of open buffers.
nmap <C-Right> :bnext!<CR>
nmap <C-Left> :bprev!<CR>

" Set up bindings for working with tabs. Because tabs are handy.
nmap <C-Tab> :tabnext<CR>
nmap <C-S-Tab> :tabprevious<CR>

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

" In visual mode, D will Duplicate the selected lines after the visual block.
vmap D y'>p']

" Creating comments, mostly for ColdFusion
" These should be placed in a ColdFusion filetype file
imap <C-o> <!---  ---><ESC>hhhhi

" Ctrl-E while in insert mode moves the cursor to the end of the line, a la
" OS X and other UN*X interfaces (e.g. bash).
imap <C-e> <Esc>A

" Ctrl-Enter while in insert mode places a set of braces, great for starting
" functions and CSS style blocks.
" This should also be in filetype-specific file(s).
imap <C-> {<CR>}<Esc>O

" \th = toggle highlight
" Toggle the highlighting of the most recently found search text. I use this
" one all the time.
nnoremap <leader>th :set invhls hls?<CR>

" Allow the up and down arrows to move between LOGICAL lines of text on the
" screen, even if they are wrapped portions of the same LITERAL line of text.
" Works in any mode.
map <Up> gk
map <Down> gj

" Mappings for easier split window navigation:
" Ctrl-w followed by u and d for up and down moves you to the next window
" either up or down and maximizes it all at once.
nmap <C-w>u <C-w><Up><C-w>_
nmap <C-w>d <C-w><Down><C-w>_

" Ctrl-Up and Ctrl-Down (in normal mode) moves to the next window either up or
" down, maximizes it, and centers the window on the current line.
nmap <C-Up> <C-w><Up><C-w>_z.
nmap <C-Down> <C-w><Down><C-w>_z.

" ----------------------------- Omnicompletion --------------------------------
" Remap the omnicompletion commands because all the <C-x> shit is annoying.
" Words
inoremap <Leader><Tab> <C-x><C-o>

" Filenames
inoremap <Leader>: <C-x><C-f>

" Lines
inoremap <Leader>= <C-x><C-l>

" Toggle number and relativenumber (requires this little function)
function! ToggleNumbering()
    if &number == 1
        setlocal relativenumber
    else
        setlocal number
    endif
endfunction
nmap <Leader>n :call ToggleNumbering()<CR>

nmap <C-P> :CtrlP<CR>
nmap <Leader>b :CtrlPBuffer<CR>
