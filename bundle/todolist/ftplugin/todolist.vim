let s:cpo_save = &cpo
set cpo&vim

setlocal comments=b:#,f:-
setlocal formatoptions=qnwta
setlocal spell

" Folding
setlocal foldmethod=expr
setlocal foldexpr=TodoFoldLevel(v:lnum)
setlocal fillchars="fold: "

setlocal shiftwidth=2
setlocal tabstop=2

function! SetCurrentTask()
	" Start at the beginning of the line, anyway.
	normal |
	" See if this is the current task already.
	if search('>>', 'n', line('.')) > 0
		" Delete the marker
		normal |/>>dW
	else
		" Create a new marker
		normal |/-a >>
	endif
endfun

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
	exe "normal A (duration ".duration.")\<ESC>"
endfunction

function! FormatDate(datestring)
	let newdate = substitute(system("c:/cygwin/bin/date.exe -d '".a:datestring."' +'%a %F'"), "\n", "", "g")
	return newdate
endfunction

function! FormatDateWord()
	let old_z = @z
	normal "zyiW
	let @z = '['.FormatDate(@z).']'
	normal ciWz
	let @z = old_z
endfunction

function! TodoFoldText()
	let lines = v:foldend - v:foldstart + 1
	return substitute(v:folddashes[2:], '-', '  ', 'g').getline(v:foldstart).' ('.lines.')'
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

nmap <Leader>tt :call SetCurrentTask()<CR>
nmap <Leader>tc gg/>>z.
nmap <Leader>td :call PrintDuration()<CR>
nmap <Leader>ta zR:g/DONE\\|HELD/call CloseFoldIfOpen()<CR>
nmap <Leader>ty zM:exe ":g/".strftime("%Y-%m-%d")."/call OpenFoldIfClosed()"<CR>gg

let &cpo = s:cpo_save
unlet s:cpo_save
