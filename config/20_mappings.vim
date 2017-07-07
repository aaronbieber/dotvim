" Allows incsearch highlighting for range commands.
cnoremap ~~c <CR>:t''<CR>
cnoremap ~~m <CR>:m''<CR>
cnoremap ~~d <CR>:d<CR>``

" Open the current line of the current file in our online codebase search.
nnoremap gS :call system("xdg-open http://dox.wayfair.com/source/xref/php/" . expand("%") . '\#' . line('.'))<CR>
vnoremap gO "ay :call system("xdg-open " . @a)<CR>gv

" Insert the required number of spaces to move the cursor to align with the next
" column of text based upon the line immediately above the cursor's location.
" This has the effect of allowing you to easily move to the next 'hanging
" indent' location.
"
" Example:
"
" The quick brown fox jumped over the lazy dog.
"      |
"
" With the cursor at the location of the pipe, pressing <Leader><Tab> will
" insert spaces adequate to move the cursor to directly beneath the 'b' in
" 'brown'. Pressing <Leader><Tab> again will move the cursor to beneath the 'f'
" in 'fox'.
function! HangingIndentAlignCol()
    if line('.') > 1
        let previous_line = getline(line('.') - 1)
        let next_column = match(previous_line, ' \zs[^ ]', col('.'))
        echom "HangingIndentAlignCol: matched on offset " . next_column

        if next_column > -1
            " match() returns a byte offset. Convert to a column number by
            " adding one.
            "let next_column += 1

            "echom "HangingIndentAlignCol: cursor column is " . col('.')
            let thecount = next_column - col('.')
            let operator = 'a'

            if col('$') == 1
                let thecount += 1
            endif

            " The cursor is NOT at the end of the line.
            if col('.') < (col('$') - 1)
                " Use 'i' to insert before the cursor if we're not at the end.
                let operator = 'i'

                " If the cursor is not in the first column, move it forward to
                " compensate for having just pressed <Esc> to leave insert mode.
                if col('.') > 1
                    exec "normal l"
                else
                    " If the cursor is in the first column (but not at the end
                    " of the line), then we are inserting spaces before text
                    " that already exists on this line. Add one more space
                    " to the offset to compensate for that.
                    let thecount += 1
                endif
            endif

            "echom "HangingIndentAlignCol: add " . thecount . " spaces with '" . operator . "' to col " . next_column
            exec "normal " . thecount . operator . " \<Esc>"
        endif
    endif
endfunction

inoremap <Leader><Tab> <Esc>:call HangingIndentAlignCol()<CR>a

" Add ten spaces before the cursor with ,<Space>. Handy for re-indenting lines
" that don't automatically wrap (like wrapping docblock comments).
nnoremap <Leader><Space> 10i<Space><Esc>l

" Change colors (mnemonic: change your colors {light|dark}).
nnoremap cycl :colorscheme Tomorrow<CR>
nnoremap cycd :colorscheme xoria256<CR>

" Pass the selected lines through tidy with ,x.
vnoremap <Leader>x :<Home>silent <End>!tidy -q -i --show-errors 0<CR>

" Instead of using the not-so-awesome 'gf', use my awesome one.
nnoremap gf :call Awesomegf()<CR>

" Let's try this for a while. I'm still skeptical.
inoremap jk <Esc>

" Reformat paragraph.
nnoremap <Leader>rp vipJVgq

" Toggle paste mode.
nnoremap <Leader>, :set paste!<CR>

" Easily edit the alternate file without having to reach up and hit Ctrl-6.
" Because my <Leader> is set to comma, I just hit `,,` to run this.
nnoremap <Leader>. :e #<CR>

" Toggle search highlighting.
nnoremap <Space> :set hlsearch!<CR>

" Display a list of all search matches. This mapping cleverly uses the :g
" command to find lines matching the last-used search pattern and implicitly
" runs its default command "p", which prints matches.
nnoremap g/ :g//<CR>

" Y yanks to the end of the line, as you would expect it to.
nnoremap Y y$

" Leader-s toggles syntastic, which displays errors for 'interpretable' files.
nnoremap <Leader>s :SyntasticToggleMode<CR>

" Delete trailing whitespace.
nnoremap <Leader>S :call StripTrailingWhitespace()<CR>

" Create surrounding HTML tags out of the word near the cursor.
inoremap <C-a> <Esc>viwc<"></"><Esc>cit

" Set Shift-Left and Shift-Right to scroll left and right. Helpful while using
" the diff function.
nnoremap <S-Left> 5zh
nnoremap <S-Right> 5zl

" Map the movement command that cycles through diff changes to also center the
" line vertically in the window when it is arrived at. It's convenient.
nnoremap ]c ]cz.
nnoremap [c [cz.

" Indent or 'outdent' the last 'put' block with shift-tab (outdent) and tab
" (indent). This way you can put a block and immediately move it to the
" correct indention. This is probably my favorite mapping.
nnoremap <S-Tab> '[<lt>']
nnoremap <Tab> '[>']

nnoremap [j <C-o>
nnoremap ]j <C-i>

" Ctrl-E while in insert mode moves the cursor to the end of the line, a la
" OS X and other UN*X interfaces (e.g. bash).
inoremap <C-e> <Esc>A

" Allow the up and down arrows to move between LOGICAL lines of text on the
" screen, even if they are wrapped portions of the same LITERAL line of text.
" Works in any mode.
noremap <Up> gk
noremap <Down> gj

" Mappings for easier split window navigation:
" Ctrl-w followed by u and d for up and down moves you to the next window
" either up or down and maximizes it all at once (accordion mode).
nnoremap <C-w>u <C-w><Up><C-w>_
nnoremap <C-w>d <C-w><Down><C-w>_

" Why don't I do this like everyone else?
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" ----------------------------- Omnicompletion --------------------------------
" Remap the omnicompletion commands because all the <C-x> shit is annoying.

" Words
"inoremap <Leader><Tab> <C-x><C-o>

" Filenames
inoremap <Leader>: <C-x><C-f>

" Lines
inoremap <Leader>= <C-x><C-l>

" --------------------------------- Ctrl-P ------------------------------------
nnoremap <C-p> :CtrlP<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>
nnoremap <Leader>f :CtrlPFunky<CR>

" --------------------------- Visual Mode Mappings ----------------------------
" In visual mode, D will Duplicate the selected lines after the visual block.
vnoremap D y'>p']

" Allow * and # to work the way you would expect when some text is selected.
" These use the z register for now until I can find the more elegant solution,
" which I know exists.
vnoremap * "zy/\V<C-r>z<CR>
vnoremap # "zy?\V<C-r>z<CR>

" Let ,a start an easy align command for me.
vnoremap <Leader>a :EasyAlign<CR>

" vim: set et ts=4 sw=4 :
