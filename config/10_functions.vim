" Search for the next line with the same indention (nice for finding start/end
" of blocks)
function! MatchIndentForward()
	"Get the current line into a register.
	normal "xyy
	let b:indent = matchlist(@x, '^\(\t\{-}\)[^\t]')
	if !empty(b:indent)
		let @/ = '^\t\{' . len(b:indent[1]) . '}[^\t]'
		execute "normal /" . '^\t\{' . len(b:indent[1]) . '}[^\t]' . "\<CR>"
	endif
	setlocal hlsearch
endfun
nmap <leader>if :call MatchIndentForward()<CR>

" And also in reverse.
function! MatchIndentBackward()
	"Get the current line into a register.
	normal "xyy
	let b:indent = matchlist(@x, '^\(\t\{-}\)[^\t]')
	if !empty(b:indent)
		let @/ = '^\t\{' . len(b:indent[1]) . '}[^\t]'
		execute "normal ?" . '^\t\{' . len(b:indent[1]) . '}[^\t]' . "\<CR>"
	endif
	setlocal hlsearch
endfun
nmap <leader>ib :call MatchIndentBackward()<CR>

fun! CommentLines()
	normal `>mu`<myv"ay
	if (col('.') == 1) || (char2nr(@a) == 9)
		if (&filetype == "css")
			execute "normal O/*\<ESC>`u"
			execute "normal o*/\<ESC>"
		elseif (&filetype == "cf")
			execute "normal O<!-------------------------------------------------------------------------------------------------\<ESC>`u"
			execute "normal o-------------------------------------------------------------------------------------------------->\<ESC>"
		endif
	else
		if (&filetype == "css")
			execute "normal `ua*/\<ESC>`yi/*\<ESC>"
		elseif (&filetype == "cf")
			execute "normal `ua--->\<ESC>`yi<!---\<ESC>"
		endif
	endif
endfun
vmap <C-p> <ESC>:call CommentLines()<CR>

" Pressing capital Q destroys the buffer. I use this more than ,bd anyway.
function! DeleteBufferOrQuit()
	if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1
		execute "bdelete!"
	elseif winnr('$') == 1
		execute "q!"
	endif
endfunction
nmap Q :call DeleteBufferOrQuit()<CR>

" Function: TitleCase()
"
" Convert the selected area into title case capitalization.
"
" old sentence = New Sentence
"
" TODO: It would be great if it could ignore prepositions
" 		and conjunctions automatically.
fun! TitleCase()
	'<,'>s/./\L&/g
	'<,'>s/\w*/\u&/g
endfun

" Take the text output from SQL Management Studio and convert it into insert 
" statements. This is hackish and doesn't always work, but when it does, damn 
" is it cool This is hackish and doesn't always work, but when it does, damn 
" is it cool
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
