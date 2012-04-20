" This is my previous statusline:
"set statusline=%<%f\ %h%m%r\ %=
"set statusline+=%20{BCFStatusLineElement()}
"set statusline+=%3{BCFStatusLineElementTicket()}
"set statusline+=%3{BCFStatusLineElementFileStatus()}
"set statusline+=\ %-14.(%l,%c%V%)\ %P

" ------------------------- Statusline components ----------------------------
"statusline setup
set statusline=
set statusline+=%#statusline#
set statusline+=%f\ 							"tail of the filename
set statusline+=%#statuslinenc#

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%#statuslinenc#

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%#statuslinenc#

set statusline+=%h								"help file flag
set statusline+=%y								"filetype
set statusline+=%r								"read only flag
set statusline+=%m								"modified flag

"set statusline+=%{fugitive#statusline()}

"display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%#statuslinenc#

set statusline+=%#warningmsg#
set statusline+=%{StatuslineTrailingSpaceWarning()}
set statusline+=%#statuslinenc#

set statusline+=%{StatuslineLongLineWarning()}

"display a warning if &paste is set
set statusline+=%#question#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%#statuslinenc#

set statusline+=%=								"left/right separator
set statusline+=%#statusline#
set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
set statusline+=%c,								"cursor column
set statusline+=%l/%L							"cursor line/total lines
set statusline+=\ %P							"percent through file
set laststatus=2

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
	if !exists("b:statusline_trailing_space_warning")

		if !&modifiable
			let b:statusline_trailing_space_warning = ''
			return b:statusline_trailing_space_warning
		endif

		if search('\s\+$', 'nw') != 0
			let b:statusline_trailing_space_warning = '[\s]'
		else
			let b:statusline_trailing_space_warning = ''
		endif
	endif
	return b:statusline_trailing_space_warning
endfunction


"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
	let name = synIDattr(synID(line('.'),col('.'),1),'name')
	if name == ''
		return ''
	else
		return '[' . name . ']'
	endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
	if !exists("b:statusline_tab_warning")
		let b:statusline_tab_warning = ''

		if !&modifiable
			return b:statusline_tab_warning
		endif

		let tabs = search('^\t', 'nw') != 0

		"find spaces that arent used as alignment in the first indent column
		let spaces = search('^ \{' . &ts . ',}[^\t]', 'nw') != 0

		if tabs && spaces
			let b:statusline_tab_warning =  '[mixed-indenting]'
		elseif (spaces && !&et) || (tabs && &et)
			let b:statusline_tab_warning = '[&et]'
		endif
	endif
	return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
	if !exists("b:statusline_long_line_warning")

		if !&modifiable
			let b:statusline_long_line_warning = ''
			return b:statusline_long_line_warning
		endif

		let long_line_lens = s:LongLines()

		if len(long_line_lens) > 0
			let b:statusline_long_line_warning = "[" .
						\ '#' . len(long_line_lens) . "," .
						\ 'm' . s:Median(long_line_lens) . "," .
						\ '$' . max(long_line_lens) . "]"
		else
			let b:statusline_long_line_warning = ""
		endif
	endif
	return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
	let threshold = (&tw ? &tw : 80)
	let spaces = repeat(" ", &ts)

	let long_line_lens = []

	let i = 1
	while i <= line("$")
		let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
		if len > threshold
			call add(long_line_lens, len)
		endif
		let i += 1
	endwhile

	return long_line_lens
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
	let nums = sort(a:nums)
	let l = len(nums)

	if l % 2 == 1
		let i = (l-1) / 2
		return nums[i]
	else
		return (nums[l/2] + nums[(l/2)-1]) / 2
	endif
endfunction
