"____Environment-specific locations____
" I only use these backup locations in Windows
if has("gui_win32")
	if !filewritable("c:\\vim_backups")
		call mkdir("c:\\vim_backups")
	endif
	set backupdir=c:\\vim_backups
	set dir=c:\\vim_backups

	if v:version > 702
		if !filewritable("c:\\vim_undo")
			call mkdir("c:\\vim_undo")
		endif
		set undodir=c:\\vim_undo
	endif
else
	if !filewritable("/tmp/vim_backups")
		call mkdir("/tmp/vim_backups")
	endif
	set backupdir=/tmp/vim_backups
	set dir=/tmp/vim_backups

	if v:version > 702
		if !filewritable("/tmp/vim_undo")
			call mkdir("/tmp/vim_undo")
		endif
		set undodir=~/.vim/undodir
	endif
endif

" <Leader>o opens the folder containing the current file in Windows.
if has("gui_win32")
	nmap <leader>o :exec "silent !start explorer.exe ".expand("%:h")<CR>
endif

" Brighter for the GUI, darker for the console.
if has("gui")
	set background=light
	let g:solarized_underline=0    		"default value is 1
	let g:solarized_visibility="low"    "default value is normal
	colorscheme jellybeans

	" Fonts differ across my platforms.
	if has("gui_macvim")
		set guifont=Menlo:h11
	elseif has("gui_gtk")
		set guifont=Inconsolata\ Medium\ 12
	else
		set guifont=DejaVu\ Sans\ Mono:h10
		"set guifont=Consolas:h11
		"set guifont=Tamsyn8x15
		"set guifont=Inconsolata-dz:h9
	endif
else
	colorscheme desert256
endif

