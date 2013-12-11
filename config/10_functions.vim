" Search for the next line with the same indention (nice for finding start/end
" of blocks)
function! MatchIndent(direction)
    if a:direction != 'f' && a:direction != 'b'
        echoe "MatchIndent only accepts one of two arguments, 'f' or 'b'."
        return
    endif

    "Get the current line into a register.
    "normal "xyy
    let @x = getline(line('.'))

    let indent_char = '\t'
    if &expandtab
        let indent_char = ' '
    endif
    let indent_pattern = '^\(' . indent_char . '*\)[^' . indent_char . ']'

    " Get physical indent.
    let indent = matchlist(@x, indent_pattern)

    let search_flags = 'n'
    if !empty(a:direction) && a:direction == 'b'
        " Set the search flags to include 'backwards'.
        let search_flags .= 'b'
        " Move the cursor up one line so reverse search doesn't match the 
        " current line.
        call cursor(line('.') - 1, col('.'))
    endif

    if !empty(indent)
        let next_matching_line = search('^' . indent_char . '\{' . len(indent[1]) . '}[^' . indent_char . ']', search_flags)
        "execute "normal /" . '^\t\{' . len(b:indent[1]) . '}[^\t]' . "\<CR>"
        if next_matching_line
            call cursor(next_matching_line, 0)
        else
            if a:direction == 'b'
                call cursor(line('.') + 1, col('.'))
            endif
        endif
    endif
endfun
nmap <leader>if :call MatchIndent('f')<CR>
nmap <leader>ib :call MatchIndent('b')<CR>

" Function: TitleCase()
"
" Convert the selected area into title case capitalization.
"
" old sentence = New Sentence
"
" TODO: It would be great if it could ignore prepositions
"         and conjunctions automatically.
function! TitleCase()
    '<,'>s/./\L&/g
    '<,'>s/\w*/\u&/g
endfun

" Take the text output from SQL Management Studio and convert it into insert
" statements. This is hackish and doesn't always work, but when it does, damn
" is it cool.
function! CreateInserts()
    " Go to the first line, which should be the header values
    " and snag it into the h register
    normal ggV"hd

    " Remove the trailing linebreak
    let @h = substitute(@h, "\n", "", "")

    " Convert the headers into a list
    let columns = split(@h, "\t")

    " Grab the remainder of the file into the d register
    " d for 'data,' get it?
    normal VG"dd

    " Split all of the lines into a list
    let rows = split(@d, "\n")
    let records = []

    " With each line, remove any linebreak that might be in there
    " and split it into distinct data elements
    for line in rows
        " Convert from a string to a list
        let records += [split(line, "\t")]
    endfor

    for record in records
        " This is the common preamble
        let newline = 'INSERT INTO table_name ('.join(columns, ', ').') VALUES ('

        " Quote the value of each column before joining
        let newrecord = []
        for cell in record
            if cell =~ 'NULL' || cell =~ '^[0-9]*$'
                let newrecord += [cell]
            else
                let newrecord += ["'".cell."'"]
            endif
        endfor

        let newline .= join(newrecord, ', ')
        let @a = newline . ")\n"
        normal "ap
    endfor
endfun

function! MarkdownFilter()
    let path_to_source_file = expand('%:p')
    let path_to_html_file = path_to_source_file . '.html'

    call system('/home/abieber/bin/mdp ' . path_to_source_file . ' > ' . path_to_html_file)
    call system('cat /home/abieber/u/notes/codehilite.css >> ' . path_to_html_file)
endfunction

function! StripTrailingWhitespace()
    let l = line('.')
    let c = col('.')
    v/^-- /s/[\r \t]\+$//e
    call cursor(l, c)
endfunction

" vim: set et ts=4 sw=4 :
