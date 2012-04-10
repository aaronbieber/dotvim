" Don't be compatible with vi.
set nocompatible

" ############################################################################
" #         Bootstrap my configuration and plugins (with Pathogen)           #
" ############################################################################

" I use vim in four environments: gVim in Windows, MacVim in OS X, and 
" terminal vim in various shells (Cygwin, OS X, Ubuntu). The major differences 
" between the environments is the way paths are expressed and my own personal 
" path preferences for storage of select files. This is the only way I could 
" come up with to close that gap efficiently.
if has("gui_win32") || has("win32unix")
	" This covers Windows and the Cygwin terminal.
	let s:config_prefix = 'c:/vim/vimfiles/'
else
	" This covers everything else, which will include MacVim and any UN*X-like 
	" shell.
	let s:config_prefix = '~/.vim/'
endif

" Load Pathogen.
call pathogen#infect()

" Fix the Solarized mapping.
call togglebg#map("")

" Now enable syntax highlighting and filetype stuff.
syntax on

" Enable filetype handling.
filetype plugin indent on

" Now process all of the configuration files that I have stored in my 'config' 
" directory, which significantly cleans up this file.
for f in sort(split(glob(s:config_prefix.'config/*.vim'), '\n'))
	execute 'source '.f
endfor

" ############################################################################
" #          Configure any plugin-specific settings and mappings.            #
" ############################################################################

" --------------------------------- TagBar -----------------------------------
if has("gui_win32")
	let g:tagbar_ctags_bin = 'c:\cygwin\bin\ctags.exe'
endif
nmap <F8> :TagbarToggle<CR>

" -------------------------------- NERDTree ----------------------------------
map <c-t> :NERDTreeToggle<CR>
let NERDTreeDirArrows=0
let NERDTreeQuitOnOpen=1

" ------------------------------- Quicktask ----------------------------------
let g:quicktask_autosave = 1
if has("gui_win32")
	let g:quicktask_snip_path = 'c:\Users\a.bieber\Dropbox\snips'
else
	let g:quicktask_snip_path = '~/Documents/snips'
endif
let g:quicktask_snip_win_maximize = 1
let g:quicktask_snip_default_filetype = "markdown"

" --------------------------------- Buffet -----------------------------------
nmap <Leader>b :Bufferlist<CR>

" -------------------------------- Snippets ----------------------------------
let snippets_dir = substitute(substitute(globpath(&rtp, 'snippets/'), "\n", ',', 'g'), 'snippets\\,', 'snippets,', 'g')

" -------------------------------- Supertab ----------------------------------
let g:SuperTabMappingForward = '<c-space>'
let g:SuperTabMappingBackward = '<s-c-space>'

" ---------------------------- BuildCommitFile -------------------------------
let g:BCFCommitFilePath = "D:/svn_tools/commits/"

"____Version-specific options____
if v:version > 702
	set undofile
	set undolevels=1000
	set undoreload=10000
	au BufWritePre /tmp/* setlocal noundofile
	au BufWritePre /private/tmp/* setlocal noundofile
endif

vmap gl :<C-U>!svn blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>
