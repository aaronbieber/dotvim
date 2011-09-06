" Vim plugin to build a commit file (a text file listing paths to files to
" commit) by recording the file currently being edited into a new or existing
" commit file.
"
" Version:		1.0a
" Maintainer:	Aaron Bieber <aaron@aaronbieber.com>
" License:		??
"
" Copyright (c) 2008 Aaron Bieber
"
" Configuration options:
" 	BCFCommitFilePath			The path on disk to a location where commit
" 								files should be created/saved. Something like
"								C:/WINDOWS/Temp/
"								Make sure you have a trailing slash.

if exists('loaded_buildCommitFile')
	finish
endif
let loaded_buildCommitFile = 1

if v:version < 700
	echohl WarningMsg|echomsg "Build Commit File requires at least VIM 7.0."|echohl None
endif

" temporary values of overridden configuration variables
let s:optionOverrides = {}

" Function: BCFSetCommitFileName()
" Ask the user to enter a filename for this commit file and see if it exists
" on disk. If not, set it.
function! s:BCFSetCommitFileName(...)
	let nochange = (a:0 > 0 && a:1 =~ "nochange") ? 1 : 0

	let path = BCFGetOption("BCFCommitFilePath", "C:/WINDOWS/Temp/")
	let filename = input("Enter a name for your commit file: ")
	if(len(filename) && filereadable(path.filename.".commit"))
		" File already exists!
		if !nochange
			echohl WarningMsg|echomsg "This file already exists!"|echohl None
			echo "  y - Yes use this file, empty it first."
			echo "  a - Yes use this file, append to the existing list."
			echo "  n - No, don't use this file."
			let ans = input("Use it anyway? [y/a/N]: ")
			echo "\n"
		else
			let ans = "a"
		endif

		if(ans == "y" || ans == "Y")
			let ticket = input("Enter a ticket number [optional]: ")
			if(ticket == "")
				let g:BCFCommitFileTicket = "--"
			else
				let g:BCFCommitFileTicket = ticket
			endif

			call writefile([], path.filename.".commit")
			let g:BCFCommitFileNameBase = filename
			let g:BCFCommitFileName = filename.".commit"
		elseif(ans == "a" || ans == "A")
			" Try to recover the ticket number from the existing file.
			let g:BCFCommitFileNameBase = filename
			let g:BCFCommitFileName = filename.".commit"

			call s:BCFGetCommitFileTicket()
		endif
	elseif(len(filename))
		if !nochange
			let g:BCFCommitFileNameBase = filename
			let g:BCFCommitFileName = filename.".commit"
			let ticket = input("Enter a ticket number [optional]: ")
			if(ticket == "")
				let g:BCFCommitFileTicket = "--"
			else
				let g:BCFCommitFileTicket = ticket
			endif
		else
			echohl WarningMsg|echomsg "When selecting an existing commit file, the file must exist."|echohl None
		endif
	endif

	if(exists("g:BCFCommitFileName") && len(g:BCFCommitFileName))
		call s:BCFActivateBuffer()
	endif
endfunction

" Function: BCFGetCommitFileTicket()
" Get the existing ticket number from a commit file.
function! s:BCFGetCommitFileTicket()
	let path = BCFGetOption("BCFCommitFilePath", "C:/WINDOWS/Temp/")
	let commits = readfile(path.g:BCFCommitFileName)
	let ticket = matchlist(commits[0], '\([A-Z0-9-]*\)$')[0]
	if(ticket != "")
		echo "Using the existing ticket: ".ticket
		let g:BCFCommitFileTicket = ticket
	else
		let g:BCFCommitFileTicket = "--"
	endif
endfunction

" Function: s:BCFUnsetCommitFileName()
" Remove the commit file definition for this Vim instance.
function! s:BCFUnsetCommitFileName()
	unlet g:BCFCommitFileNameBase
	unlet g:BCFCommitFileName
	unlet g:BCFCommitFileTicket
endfunction

" Function: s:BCFPathFormat(path)
" Format a path returned by expand() into the format we want in our commit
" file. The user might want to customize this behavior. I don't know how to do
" that elegantly.
function! s:BCFPathFormat(path)
	let thefile = a:path
	let thefile = substitute(thefile, "\\", "/", "g")
	let thefile = substitute(thefile, "J:", "/cygdrive/j", "")
	return thefile
endfunction

" Function: s:BCFPathUnFormat(path)
" Reverse path formatting from posix back to Windows to be able to do Windows
" things with it.
function! s:BCFPathUnFormat(path)
	let thefile = a:path
	let thefile = substitute(thefile, "/cygdrive/j", "J:", "")
	let thefile = substitute(thefile, "/", "\\", "g")
	return thefile
endfunction

" Function: s:BCFAddFile()
" Add a file to the commit file list.
function! s:BCFAddFile()
	let path = BCFGetOption("BCFCommitFilePath", "C:/WINDOWS/Temp/")
	" If the filename isn't defined yet, ask for a name.
	if(!exists("g:BCFCommitFileName"))
		call s:BCFSetCommitFileName()
	endif
	" If the filename still isn't defined, one was not provided or the user
	" provided a name that already existed and declined to overwrite that
	" file.
	if(!exists("g:BCFCommitFileName"))
		echohl WarningMsg|echo "You must set a filename before you can continue."|echohl None
		return
	endif
	let thisfile = s:BCFPathFormat(expand("%:p"))
	let thisline = thisfile."\t\t\t".g:BCFCommitFileTicket
	if(filereadable(path.g:BCFCommitFileName))
		if(s:BCFExistsInCommitList(thisfile))
			let b:BCFListContainsThisBuffer = 1
			echohl WarningMsg|echo "This file already exists in the commit list!"|echohl None
			return
		endif

		let commits = readfile(path.g:BCFCommitFileName)
		let commits = commits + [thisline]
		call writefile(commits, path.g:BCFCommitFileName)
	else
		call writefile([thisline], path.g:BCFCommitFileName)
	endif

	let b:BCFListContainsThisBuffer = 1
	echo "Added ".thisfile." to the ".g:BCFCommitFileName." file."
endfunction

function! s:BCFExistsInCommitList(filename)
	let path = BCFGetOption("BCFCommitFilePath", "C:/WINDOWS/Temp/")
	if(exists("g:BCFCommitFileName"))
		if(filereadable(path.g:BCFCommitFileName))
			let commits = readfile(path.g:BCFCommitFileName)
			for line in commits
				" If the commit line is entirely found within the buffer path,
				" we presume that the buffer path's parent folder is included
				" in the commit list.
				let line_path = matchlist(line, "^[^\t]*")[0]
				if(match(a:filename, line_path) > -1)
					return 1
				endif
			endfor

			return 0
		endif
	endif

	return 0
endfunction

" Function: BCFShowCommitFile()
" Open the current commit file (if there is one) in a new buffer, splitting
" below by default.
function! s:BCFShowCommitFile()
	if(exists("g:BCFCommitFileName"))
		let path = BCFGetOption("BCFCommitFilePath", "C:/WINDOWS/Temp/")
		exec "bot split ".path.g:BCFCommitFileName
		let &filetype = "BCFCommitFile"
	else
		echohl WarningMsg|echo "There is no commit file set up in this Vim instance."|echohl None
	endif
endfunction

" Function: s:BCFOpenFile()
" Split the window and open the filename under the cursor in the commit file.
" I really should have a 'commit' file type, but I haven't gotten to that yet.
function! s:BCFOpenFile()
	let filename = expand("<cfile>")
	echo filename
	if(len(filename))
		let filename = s:BCFPathUnFormat(filename)
		echo filename
		if(filereadable(filename))
			exec "split ".filename
		endif
	endif
endfunction

" Function: BCFGetOption(name, default)
" Grab a user-specified option to override the default provided.  Options are
" searched in the window, buffer, then global spaces.
function! BCFGetOption(name, default)
	if has_key(s:optionOverrides, a:name) && len(s:optionOverrides[a:name]) > 0
		return s:optionOverrides[a:name][-1]
	elseif exists('w:' . a:name)
		return w:{a:name}
	elseif exists('b:' . a:name)
		return b:{a:name}
	elseif exists('g:' . a:name)
		return g:{a:name}
	else
		return a:default
	endif
endfunction

function! BCFStatusLineElement()
	if exists("g:BCFCommitFileNameBase")
		return "[".g:BCFCommitFileNameBase."]"
	else
		return ""
	endif
endfunction

function! BCFStatusLineElementFileStatus()
	if(exists("g:BCFCommitFileNameBase"))
		if(exists("b:BCFListContainsThisBuffer") && b:BCFListContainsThisBuffer)
			return "[*]"
		else
			return "[ ]"
		endif
	endif

	return ""
endfunction

function! BCFStatusLineElementTicket()
	if(exists("g:BCFCommitFileTicket"))
		return "[".g:BCFCommitFileTicket."]"
	else
		return ""
	endif
endfunction

function! s:BCFActivateBuffer()
	if(exists("g:BCFCommitFileName") && len(g:BCFCommitFileName))
		if(len(expand("%:p")))
			let thisfile = s:BCFPathFormat(expand("%:p"))
			if(len(thisfile))
				let b:BCFListContainsThisBuffer = s:BCFExistsInCommitList(thisfile)
			endif
		endif
	endif
endfunction

function! s:BCFCopyCommitFileName()
	call setreg('*', g:BCFCommitFileNameBase)
	echo "\"".g:BCFCommitFileNameBase."\" copied to the clipboard."
endfunction

function! BCFAddAllFiles()
	silent! bufdo! \la
endfunction

com! -nargs=0 BCFAddAllFiles call s:BCFAddAllFiles()
com! -nargs=0 BCFAddFile call s:BCFAddFile()
com! -nargs=0 BCFShowCommitFile call s:BCFShowCommitFile()
com! -nargs=0 BCFOpenFile call s:BCFOpenFile()
com! -nargs=0 BCFSetCommitFileName call s:BCFSetCommitFileName("nochange")
com! -nargs=0 BCFUnsetCommitFileName call s:BCFUnsetCommitFileName()
com! -nargs=0 BCFCopyCommitFileName call s:BCFCopyCommitFileName()

nnoremap <silent> <Plug>BCFAddAllFiles :BCFAddAllFiles<CR>
nnoremap <silent> <Plug>BCFAddFile :BCFAddFile<CR>
nnoremap <silent> <Plug>BCFShowCommitFile :BCFShowCommitFile<CR>
nnoremap <silent> <Plug>BCFOpenFile :BCFOpenFile<CR>
nnoremap <silent> <Plug>BCFSetCommitFileName :BCFSetCommitFileName<CR>
nnoremap <silent> <Plug>BCFUnsetCommitFileName :BCFUnsetCommitFileName<CR>
nnoremap <silent> <Plug>BCFCopyCommitFileName :BCFCopyCommitFileName<CR>

if !hasmapto('<Plug>BCFAddAllFiles')
	nmap <unique> <Leader>lA <Plug>BCFAddAllFiles
endif
if !hasmapto('<Plug>BCFAddFile')
	nmap <unique> <Leader>la <Plug>BCFAddFile
endif
if !hasmapto('<Plug>BCFShowCommitFile')
	nmap <unique> <Leader>ls <Plug>BCFShowCommitFile
endif
if !hasmapto('<Plug>BCFOpenFile')
	nmap <unique> <Leader>lo <Plug>BCFOpenFile
endif
if !hasmapto('<Plug>BCFSetCommitFileName')
	nmap <unique> <Leader>lg <Plug>BCFSetCommitFileName
endif
if !hasmapto('<Plug>BCFUnsetCommitFileName')
	nmap <unique> <Leader>lu <Plug>BCFUnsetCommitFileName
endif
if !hasmapto('<Plug>BCFCopyCommitFileName')
	nmap <unique> <Leader>lc <Plug>BCFCopyCommitFileName
endif

autocmd BufEnter,BufWinEnter,WinEnter,TabEnter * call s:BCFActivateBuffer()
