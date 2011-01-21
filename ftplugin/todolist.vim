let s:cpo_save = &cpo
set cpo&vim

setlocal comments=b:#,f:-
setlocal formatoptions=qnwta
setlocal spell
setlocal foldmethod=expr
setlocal foldexpr=TodoFoldLevel(v:lnum)
setlocal shiftwidth=2
setlocal tabstop=2

" Toggle the current task
nmap <Leader>tt :call SetCurrentTask()<CR>
nmap <Leader>tc gg/>>z.

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

let &cpo = s:cpo_save
unlet s:cpo_save
