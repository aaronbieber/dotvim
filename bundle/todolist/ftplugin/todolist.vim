let s:cpo_save = &cpo
set cpo&vim

setlocal comments=b:#,f:-,f:*
setlocal formatoptions=qnwta
setlocal spell

" Folding
setlocal foldmethod=expr
setlocal foldexpr=TodoFoldLevel(v:lnum)
setlocal fillchars="fold: "

setlocal shiftwidth=2
setlocal tabstop=2

" AddNextTimeToTask():
" 	Add the next timestamp to a task. If the task has no timestamps yet,
" 	add a starting time note. If it has a start with no end, add the end.
" 	If it has complete start and end notes, add a new start note.
function! AddNextTimeToTask()
	" If we are not on a task line right now, we need to search up for one.
	if match(getline(line('.')), '^\t*- ') == -1
		exe "normal! ?^\t*- \<CR>"
	endif

	" What is the indentation level of this task?
	let matches = matchlist(getline('.'), '\v^(.{-})-')
	let indent = len(matches[1])

	" The indent we want to find is the tasks's indent plus one.
	let indent = indent + 1

	" Search downward, looking for either the end of the task block or
	" start/end notes and record them. Begin on the line immediately
	" following the task line.
	let current_line = line('.')+1
	let matched = 0
	while current_line <= line('$')
		" If we are still at the correct indent level
		if match(getline(current_line), '\v^\s{'.indent.'}') > -1
			" If this line is a sub-task, we have reached our location.
			if match(getline(current_line), '\v^\s*-') > -1
				call AddStartTimeToTask(current_line-1)
				let matched = 1
				break
			" If this line is a note, we have more checking to do.
			elseif match(getline(current_line), '\v^\s*\*') > -1
				if match(getline(current_line), '\vStart \[') > -1
					if match(getline(current_line), '\v, end \[\d\d:\d\d\]') == -1
						call AddEndTimeToTask(current_line)
						let matched = 1
						break
					endif
				else
					call AddStartTimeToTask(current_line-1)
					let matched = 1
					break
				endif
			endif
		else
			" We reached the next task
			call AddStartTimeToTask(current_line-1)
			break
		endif

		let current_line = current_line + 1
	endwhile
endfunction

function! AddStartTimeToTask(start)
	" Place the cursor at the given start line.
	call cursor(a:start,0)

	" Get the timestamp string.

	let today = '['.strftime("%a %Y-%m-%d").']'
	let now = '['.strftime("%H:%M").']'

	" If the current line is a task line, we have to indent the start time. If 
	" not, then we don't.
	if match(getline('.'), '\v^\s*-') > -1
		exe "normal! o\<Tab>* Start ".today." ".now."\<Esc>"
	else
		exe "normal! o* Start ".today." ".now."\<Esc>"
	endif
endfunction

function! AddEndTimeToTask(start)
	" Place the cursor at the given start line.
	call cursor(a:start,0)

	if match(getline('.'), '\vStart \[') == -1
		call AddStartTimeToTask(a:start-1)
	endif

	" Now insert the end time.
	let now = '['.strftime("%H:%M").']'
	exe "normal! A, end ".now."\<Esc>"
endfunction

function! SetCurrentTask()
	" Store the current cursor location.
	let cursorpos = getpos('.')

	" Remove any existing task markers.
	exe "%s/- >> /- /g"

	" Restore the cursor position (this is important).
	call cursor(cursorpos[1:])

	" Find the task line. Are we on it right now? If not, search backwards.
	if match(getline(line('.')), '^\t*- ') == -1
		exe "normal! ?^\t*- \<CR>"
	endif

	" Start at the beginning of the line, anyway.
	normal! |
	" See if this is the current task already.
	if search('>>', 'n', line('.')) > 0
		" Delete the marker
		exe "normal! |/>>\<CR>dW"
		"normal! |/>>dW
	else
		" Create a new marker
		exe "normal! |/-\<CR>a >>\<Esc>"
		"normal! |/-a >>
	endif
endfunction

" TaskComplete()
" Mark a task as complete by placing a note at the very end of the task 
" containing the keyword DONE followed by the current timestamp.
function! TaskComplete()
	" If we are not on a task line right now, we need to search up for one.
	if match(getline(line('.')), '^\t*- ') == -1
		exe "normal! ?^\t*- \<CR>"
	endif

	" What is the indentation level of this task?
	let matches = matchlist(getline('.'), '\v^(.{-})-')
	" Save the actual tab characters for use in the completion bullet later.
	let physical_indent = matches[1]
	" Get the size of the indent for use in a regexp.
	let indent = len(physical_indent)

	" The indent we want to find is the tasks's indent plus one.
	let indent = indent + 1

	" Search downward, looking for either a reduction in the indentation level 
	" or the end of the file. The first line to fail to match will be the line 
	" AFTER our insertion point. Start searching on the line after the task 
	" line.
	let current_line = line('.')+1
	let matched = 0
	while current_line <= line('$')
		" If we are still at the correct indent level
		if match(getline(current_line), '\v^\t{'.indent.'}') == -1
			" Move the cursor to the line preceding this one.
			call cursor(current_line-1,0)
			" Break out, we have arrived.
			break
		endif

		let current_line = current_line + 1
	endwhile

	" Create the timestamp.

	let today = '['.strftime("%a %Y-%m-%d").']'
	" Save the contents of register 'a'.
	let old_a = @a
	" Create the DONE line and save it in register 'a'.
	let @a = physical_indent."\t"."* DONE ".today
	" Insert the DONE line.
	exe "normal! o\<Esc>\"aP"
	" Restore the value of register 'a'.
	let @a = old_a
endfunction

function! TodoFoldLevel(linenum)
	let pre_indent = indent(a:linenum-1) / &tabstop
	let cur_indent = indent(a:linenum) / &tabstop
	let nxt_indent = indent(a:linenum+1) / &tabstop

	if nxt_indent == cur_indent + 1
		return '>'.nxt_indent
	elseif pre_indent == cur_indent && nxt_indent < cur_indent
		return '<'.cur_indent
	else
		return cur_indent
	endif
endfunction

function! GetEpoch(timestring)
	return system("ruby -e 'require \"time\"; print Time.parse(ARGV[0]).to_i' -- ".a:timestring)
endfunction

function! GetDuration(times)
	let epochs = [ GetEpoch(a:times[0]), GetEpoch(a:times[1]) ]
	let difference = (epochs[1] - epochs[0]) / 60
	let duration = ''

	if difference > 60
		let duration .= (difference / 60).'h'
		let difference = difference % 60
	endif
	if difference > 0
		if len(duration) > 0
			let duration .= ' '
		endif
		let duration .= difference.'m'
	endif

	return duration
endfunction

function! GetTimes()
	let times = matchlist(getline('.'), '\v\[(\d\d:\d\d)\].*\[(\d\d:\d\d)\]')
	return [ times[1], times[2] ]
endfunction

function! PrintDuration()
	let times = GetTimes()
	let duration = GetDuration(times)
	exe "normal! A (duration ".duration.")\<ESC>"
endfunction

function! FormatDate(datestring)
	let newdate = substitute(system("c:/cygwin/bin/date.exe -d '".a:datestring."' +'%a %F'"), "\n", "", "g")
	return newdate
endfunction

function! FormatDateWord()
	let old_z = @z
	exe "normal! \"zyiW"
	let @z = '['.FormatDate(@z).']'
	exe "normal! ciW\<C-R>\<Esc>"
	let @z = old_z
endfunction

function! TodoFoldText()
	let lines = v:foldend - v:foldstart + 1
	return substitute(getline(v:foldstart), "\t", '  ', 'g').' ('.lines.')'
endfunction

set foldtext=TodoFoldText()

function! CloseFoldIfOpen()
	if foldclosed(line('.')) == -1
		silent! normal zc
	endif
endfunction

function! OpenFoldIfClosed()
	if foldclosed(line('.')) > -1
		execute "silent! normal ".foldlevel(line('.'))."zo"
	endif
endfunction

function! ShowActiveTasksOnly()
	exe "normal! zR:g/DONE\\|HELD/call CloseFoldIfOpen()\<CR>gg"
endfunction

nmap <Leader>tt :call SetCurrentTask()<CR>
nmap <Leader>tc gg/>>z.
nmap <Leader>td :call TaskComplete()<CR>
nmap <Leader>ta :call ShowActiveTasksOnly()<CR>
nmap <Leader>ty zM:exe ":g/".strftime("%Y-%m-%d")."/call OpenFoldIfClosed()"<CR>gg
nmap <Leader>ts :call AddNextTimeToTask()<CR>

let &cpo = s:cpo_save
unlet s:cpo_save
