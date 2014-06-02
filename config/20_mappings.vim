" Allows incsearch highlighting for range commands.
cnoremap ~~c <CR>:t''<CR>
cnoremap ~~m <CR>:m''<CR>
cnoremap ~~d <CR>:d<CR>``

function! HangingIndentSetCol()
    let b:hanging_indent_col = string(col('.'))

    " Add a colorcolumn if we need it.
    if index(split(&colorcolumn, ','), b:hanging_indent_col) == -1
        let &colorcolumn = &colorcolumn . ',' . b:hanging_indent_col
    endif

    echo "Hanging indent column set to " . b:hanging_indent_col
endfunction

function! HangingIndentAlignCol()
    if line('.') > 1
        let previous_line = getline(line('.') - 1)
        let next_column = match(previous_line, ' [^ ]', col('.') - 1)
        if next_column > -1
            let next_column += 1
            exec "normal " . (next_column - col('.') + 1) . "i \<Esc>l"
        endif
    endif

    return

    if !exists('b:hanging_indent_col') || b:hanging_indent_col == ''
        echom "No hanging indent is set!"
    else
        let b:count = b:hanging_indent_col - col('.')
        exec "normal " . b:count . "i \<Esc>l"
    endif
endfunction

function! HangingIndentUnsetCol()
    let colorcolumn_list = split(&colorcolumn, ',')
    if len(colorcolumn_list) > 1 && index(colorcolumn_list, b:hanging_indent_col) > -1
        let hanging_indent_index = index(colorcolumn_list, b:hanging_indent_col)
        call remove(colorcolumn_list, hanging_indent_index)
        let &colorcolumn = join(colorcolumn_list, ',')
    endif

    let b:hanging_indent_col = ''
endfunction

nnoremap chs :call HangingIndentSetCol()<CR>
nnoremap chu :call HangingIndentUnsetCol()<CR>
nnoremap <Leader><Tab> :call HangingIndentAlignCol()<CR>
inoremap <Leader><Tab> <Esc>:call HangingIndentAlignCol()<CR>a

" Add ten spaces before the cursor with ,<Space>. Handy for re-indenting lines 
" that don't automatically wrap (like wrapping docblock comments).
nnoremap <Leader><Space> 10i<Space><Esc>l

" Change colors (mnemonic: change your colors {light|dark}).
nnoremap cycl :colorscheme Tomorrow<CR>
nnoremap cycd :colorscheme xoria256<CR>

" Pass the selected lines through tidy with ,x.
vnoremap <Leader>x :<Home>silent <End>!tidy -q -i --show-errors 0<CR>

" Try to ween myself off of pressing zero ALL THE TIME.
nnoremap 0 :echoe "Stop doing that!"<CR>

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
nnoremap <Leader>t :CtrlPTag<CR>

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
