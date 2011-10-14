" Don't be compatible with vi.
set nocompatible

" Cycle filetype
autocmd!
filetype off

if !has("signs")
	let loaded_showmarks = 1
endif

" Load Pathogen
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Now enable syntax highlighting and filetype stuff.
filetype plugin indent on
syntax on

" PROCEED!

let snippets_dir = substitute(substitute(globpath(&rtp, 'snippets/'), "\n", ',', 'g'), 'snippets\\,', 'snippets,', 'g')
let g:SuperTabMappingForward = '<c-space>'
let g:SuperTabMappingBackward = '<s-c-space>'

" Brighter for the GUI, darker for the console.
if has("gui")
	colorscheme sorcerer
else
	colorscheme darkblue
endif

set backupskip=/tmp/*,/private/tmp/*

" colorscheme tango-morning
" colorscheme mustang
" colorscheme sorcerer
" colorscheme blueshift
" colorscheme liquidcarbon
" colorscheme desert2
" colorscheme pyte

set hidden
set autoindent					" Maintain indent levels automatically
set backspace=2					" Allow backspacing in basically every possible situation (the way I like it)
set foldcolumn=4				" Show a 4-column gutter to the left for folding characters
set foldmethod=marker			" Fold on markers; {{{ and }}} by default
set formatoptions=tqnw
set guifont=Consolas:h11
set ignorecase smartcase		" Case insensitive search unless caps are used in search term
set incsearch
set laststatus=2				" Always show the status line
set textwidth=0					" By default, don't wrap at any specific column.
set linebreak wrap				" Wrap text while typing (this is a soft wrap without textwidth set)
set mouse=a						" Allow use of the mouse in all situations
set nu							" Use line numbering
set shiftwidth=4				" That means I like to indent by that amount as well
set ts=4						" Tab stop is 4
set whichwrap=h,l,~,[,]
set wildmenu					" Tab completion for files with horizontal list of choices
set winminheight=0				" Allow window split borders to touch
set scrolloff=5					" Don't let the cursor get fewer than 5 lines away from the edge whenever possible.
set modeline					" Always read modeline stuff from the bottom of files.
let mapleader=","
"let g:user_zen_leader_key = '<c-h>'

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
		set undodir ~/.vim/undodir
	endif
endif

if v:version > 702
	set undofile
	set undolevels=1000
	set undoreload=10000
	au BufWritePre /tmp/* setlocal noundofile
	au BufWritePre /private/tmp/* setlocal noundofile
endif

" Use my own status line
set statusline=%<%f\ %h%m%r\ %=%20{BCFStatusLineElement()}%3{BCFStatusLineElementTicket()}%3{BCFStatusLineElementFileStatus()}\ %-14.(%l,%c%V%)\ %P 

" I have no idea what this does.
" map <leader>bd :bufdo! %s/\(^[A-Z][^ ]\{-}:.*$\n\)\n\(^[A-Z][^ ]\{-}:.*$\)/\1\2/

map <leader>c :copen<CR>
map <leader>cc :cclose<CR>
map <leader>r :registers<CR>
map <leader>bb :TBE<CR>
map <leader>bm :TBEMinimal<CR>
map <leader>bg :TBESimpleGroup<CR>

" Y yanks to the end of the line
nmap Y y$

" shortcuts for copying to/pasting from the clipboard
nmap <leader>y "*y
vmap <leader>y "*y
nmap <leader>Y "*yy
nmap <leader>p "*p
nmap <leader>P "*P

imap <C-A> <ESC>viwc<"></"><ESC>cit

"let g:VCSCommandSVNExecGlobalOptions = "--username a.bieber --password villiferous005"
let g:showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'`^\""
let g:BCFCommitFilePath = "D:/svn_tools/commits/"

" Cursor line is awesome, but it chews up resources when it's running in lots
" of windows or buffers, so turn it off when leaving and back on when
" returning.
" autocmd WinEnter * setlocal cursorline
" autocmd WinLeave * setlocal nocursorline
" autocmd BufEnter * setlocal cursorline
" autocmd BufLeave * setlocal nocursorline

" Set some other options for ColdFusion files.
autocmd FileType cf set formatoptions=croql textwidth=180
autocmd FileType cf nnoremap p ]p
autocmd FileType cf nnoremap P ]P
autocmd BufRead,BufNewFile *.txt setfiletype text

autocmd BufRead,BufNewFile *.wiki setfiletype wiki

autocmd BufEnter * lcd %:p:h

fun! WrapCfoutput()
	:%s/<\/\?cfoutput>//g
	execute "normal ggO<cfoutput>\<ESC>"
	execute "normal Go</cfoutput>\<ESC>"
endfun
nmap <leader>cfo :call WrapCfoutput()<CR>

nmap <leader>o :exec "silent !start explorer.exe ".expand("%:h")<CR>

" Make search movements center the result in the window.
nnoremap n nzz
nnoremap N Nzz

" This is still of very questionable utility.
imap jj <ESC>

" Use TextMate Control-T mapping for Fuzzy Finder file find.
nmap <C-t> :FufFile<CR>

" This will cause VIM to automatically enter 'binary' mode when writing files
" that are in /custom_tags/ so that they will be saved without a terminating
" linebreak (at the end of the file). :h binary for more information.
autocmd BufWritePre */custom_tags/*.cfm	setl binary noeol
autocmd BufWritePost */custom_tags/*.cfm	setl nobinary eol

" 'Maximize' a split with F6.
nmap <F6> <C-W>_

" Set up Ctrl-Left and Ctrl-Right to cycle through buffers (invisible
" windows). Helpful when you use the right click command 'open all in single
" Vim' to move through them. Use :buffers to view list of open buffers.
nmap <C-Right> :bnext!<CR>
nmap <C-Left> :bprev!<CR>

" Set up bindings to move between tabs.
nmap <C-Tab> :tabnext<CR>
nmap <C-S-Tab> :tabprevious<CR>

" Set Shift-Left and Shift-Right to scroll left and right. Helpful while using
" the diff function.
nmap <S-Left> 5zh
nmap <S-Right> 5zl

" Map the movement command that cycles through diff changes to also center the
" line vertically in the window when it is arrived at. It's convenient.
nmap ]c ]cz.
nmap [c [cz.

" Indent or 'outdent' the last 'put' block with Ctrl-H (outdent) and Ctrl-L
" (indent). This way you can put a block and immediately move it to the
" correct indention. This is probably my favorite mapping.
nmap <C-h> '[<lt>']
nmap <C-l> '[>']

" Re-select the same block when indenting or 'outdenting' text in visual mode,
" allowing you to continue to indent or 'outdent' repeatedly. Thanks to 0sse
" from reddit for this one.
"vnoremap < <gv
"vnoremap > >gv

" In visual mode, D will Duplicate the selected lines after the visual block.
vmap D y'>p']

" Allow the html syntax file to recognize improper comments.
" Because I use them. Improperly.
let g:html_wrong_comments = 1

let g:proj_flags = "imstTg"
function! SaveUploadFile()
	let devname = input("Developer name: ")
	let filename = 'c:\uploads\' . strftime("%Y-%m-%d") . '-' . devname . '.upload'
	exec "sav! ".filename
endfunction

function! OpenAll()
	edit <cfile>
	bfirst
endfunction

fun! OpenCurrentDirectory()
	exec "!start explorer.exe ".expand("%:h")
endfun

function! FixJQuery()
	silent! %s/\$(/jQuery(/g
	silent! %s/\$\./jQuery./g
endfunction

function! SetWindowTitle()
	let g:wtitle = input("New title: ")
	if g:wtitle == ''
		unlet g:wtitle
	endif
	call RestoreWindowTitle()
endfunction

function! RestoreWindowTitle()
	if exists("g:wtitle")
		let &titlestring = g:wtitle . ' - ' . expand("%:t") . ' (%f) %m'
	else
		let &titlestring = expand("%:t") . ' (%f) %m'
	endif
endfunction

"nnoremap <C-T> :call SetWindowTitle()<CR>
"auto BufEnter * call RestoreWindowTitle()

" Begin all of MY SETTINGS.

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

" Creating comments, mostly for ColdFusion
" These should be placed in a ColdFusion filetype file
imap <C-o> <!---  ---><ESC>hhhhi
nmap <C-p> ^v$h<C-p>

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

" Ctrl-E while in insert mode moves the cursor to the end of the line, a la
" OS X and other UN*X interfaces (e.g. bash).
imap <C-e> <Esc>A

" Ctrl-Enter while in insert mode places a set of braces, great for starting
" functions and CSS style blocks.
" This should also be in filetype-specific file(s).
imap <C-> {<CR>}<Esc>O

" Set up Ctrl-Space to pop open the menu of autocomplete words; more
" convenient than pressing Ctrl-X, Ctrl-N every time, and familiar to Visual
" Studio users like me.
" Don't do this for now, I'm using other plugins that conflict with this.
" inoremap <C-Space> 

" Color definitions:
" What are these for?
" highlight search ctermfg=0
" highlight comment ctermfg=6

" A couple of environment variables for the spelling stuff.
let IspellLang = 'english'
" I don't even have this file anymore?
" let PersonalDict = '~/.aspell_' . IspellLang

" \th = toggle highlight
" Toggle the highlighting of the most recently found search text. I use this
" one all the time.
nnoremap <leader>th :set invhls hls?<CR>

" Allow the up and down arrows to move between LOGICAL lines of text on the
" screen, even if they are wrapped portions of the same LITERAL line of text.
" Works in any mode.
map <Up> gk
map <Down> gj

" Mappings for easier split window navigation:
" Ctrl-w followed by u and d for up and down moves you to the next window
" either up or down and maximizes it all at once.
nmap <C-w>u <C-w><Up><C-w>_
nmap <C-w>d <C-w><Down><C-w>_

" Ctrl-Up and Ctrl-Down (in normal mode) moves to the next window either up or
" down, maximizes it, and centers the window on the current line.
nmap <C-Up> <C-w><Up><C-w>_z.
nmap <C-Down> <C-w><Down><C-w>_z.

" Pressing capital Q destroys the buffer. I use this more than ,bd anyway.
nmap Q :bdel!<CR>

" Pressing <leader>bd deletes the buffer without asking.
" This ties into TinyBufExplorer's <leader>b scheme; for me it's ,bd
nmap <Leader>bd :bdelete!<CR>

" Use smart indention on CSS files, because I like it.
autocmd FileType css set smartindent
" Use smart indention on PHP files, too.
autocmd FileType php set smartindent
" And in PERL for chrissake.
autocmd FileType perl set smartindent
" And in goddamned ColdFusion mother of god.
autocmd FileType cf set smartindent
" Wouldn't you think we'd smart indent in JavaScript for the love of god?
autocmd FileType javascript set smartindent noautoindent nocindent
autocmd FileType xhtml inoremap <S-CR> <br />
autocmd FileType cf inoremap <S-CR> <br />
autocmd FileType ruby set ts=2 sw=2 autoindent smartindent expandtab
autocmd FileType vim set ts=4 sw=4
autocmd FileType python set expandtab ts=2 sw=2

fun! TemplateInsert()
	normal |"qd$
	normal dd
	normal "aP
	let @q = substitute(@q, "/", "\%2F", "g")
	execute "'[,']s/%%/" . @q . "/g"
	execute "'[,']s/@@/" . substitute(@q, " ", "-", "g") . "/g"
	normal ']j
endfun

"nmap <C-T> :call TemplateInsert()<CR>

fun! ReplaceURL()
	normal |"qd$
	normal ddma
	execute "normal /##\<CR>"
	normal di"
	normal "qP
endfun

"nmap <C-E> :call ReplaceURL()<CR>

fun! TransformMySQLXML()
	" Replace <root> and </root> with <jobs> and </jobs>, respectively.
	%s/<\(\/\?\)root>/<\1jobs>/
	" Replace <row> and </row> with <job> and </job>, respectively.
	%s/<\(\/\?\)row>/<\1job>/
	" Replace <field name="foo"> ... </field> with <foo> ... </foo>.
	%s/<field name="\(.\{-}\)">\(\_.\{-}\)<\/field>/<\1><![CDATA[\2]]><\/\1>/
	" Remove qw{ <html> </html> <body> </body> <head> </head> } tags.
	%s/<\/\?html>\|<\/\?head>\|<\/\?body>//g
	" Delete DOS linebreaks.
	%s///g
	" Delete blank lines (lines containing nothing or only spaces).
	g/^\s*$/normal dd
endfun

fun! HTMLEntities()
	%s/&lt;/</g
	%s/&gt;/>/g
	%s/&quot;/"/g
	%s/&amp;/&/g
	" Only for entities that were encoded more than once, e.g. &amp;#1234;
	" should be &#1234;
	%s/&amp;\(#\d\{-}\);/\&\1/g
endfun

fun! TemplateListTrim()
	" Delete blank lines.
	silent! g/^\s*$/normal dd
	" Remove the prefix stuff that looks like: * 12)
	silent! %s/^\(\s\|\*\|#\|\d\+)\)*//
	" Remove the links at the end: edit | delete
	silent! %s/\s\?\sedit\s\s\?|\sdelete//
endfun

fun! TemplateGetNames()
	" Trim the IDs: (1234|1234)
	silent! %s/\s([0-9|]*)\s*$//
endfun

fun! TemplateGetTrueID()
	%s/^.*|\(\d\+\))/\1/
endfun

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

" Function: FormatJobsFile()
"
" Take a CSV containing job data (from iKorb) and convert it into
" a usable CSV with no dos linebreaks in it and other silly things.
"
fun! FormatJobsFile()
	echo "Replace DOS linebreaks with HTML breaks."
	silent! %s//<br \/>/g
	echo "Replace multi-escaped quotes with plain quotes."
	silent! %s/\\\+'/'/g
	silent! %s/\\\+"/"/g
	echo "Remove EOT and LF characters."
	silent! %s///g
	silent! %s///g
	echo "Remove pseudo-escaped linebreaks."
	silent! %s/\\\n//g
	echo "Replace pseudo-escaped tabs with spaces."
	silent! %s/\\	/ /g
endfun

" Function: FormatWordHTML()
"
" Do a lot of formatting to convert one certain type of Word HTML
" output into a usable file.
"
" May have other applications.
"
" TODO: This should have a lot more comments in it.
"
fun! FormatWordHTML()
	silent! g/^\s*$/normal dd
	silent! g/&nbsp;/normal dd
	silent! %s/<\/\?p.\{-}>//g
	silent! %s/<\(\/\)\?b>/<\1h4>/g
	silent! %s/<i>\( \|\s\)*/<i>/
	silent! %s/^\( \|\s\)*//
	silent! %s/<\/\?span.\{-}>//g 
	silent! g/^<a\s*$/normal J
	silent! %s/<\/a>$/<\/a><br \/>/
	silent! %s/<\(\/\)\?i>/<\1h5>/g
endfun

" Function: FormatWebResources()
"
" Do a lot of formatting to convert one certain type of Word HTML
" output into a usable file.
"
" May have other applications.
"
" TODO: This should have a lot more comments in it.
"
fun! FormatWebResources()
	normal 1GvG100<
	%s/<br>//g
	v/"text"\|"smalltext"\|"smallboldtext"/normal dd
	%s/<span class="text">\(.\{-}\)<\/span>.*$/<h4>\1<\/h4>/g
	%s/<span class="smallboldtext">[^a-zA-Z0-9]*\(.\{-}\)<\/span>.*$/<h5>\1<\/h5>/g
	%s/<span class="smalltext">\(.\{-}\)<\/span>.*$/\1<br \/>/g 
endfun

"nmap <C-T> ^"ad$dd^"bd$i<a href=""bpA">"apA</a>

" Function: CountJobs()
"
" Counts the occurrences of <job> in a file and prints out
" how many there are. It ONLY WORKS if <job> tags occur on their
" OWN LINES. One big, long, solid line of XML with 1,000 <job> tags
" in it will result in 1.
"
fun! CountJobs()
	let i=0
	let loc = getpos('.')
	silent! g/<job>/let i=i+1
	let ret = cursor(loc[1], loc[2], loc[3])
	echo "There are " . i . " jobs in this file."
endfun

" Function: ConvertLinks()
" 
" Removes the URLs from a line. The first URL is used to create
" a link to that URL using the remaining contents of the line as text.
"
" ex:
" This Site http://www.google.com is Pretty Cool
" 
" Would result in:
" <a href="http://www.google.com">This Site is Pretty Cool</a>
"
" All double-spaces and extra space is trimmed. Can be called on a
" range, but acts on each line individually.
"
fun! ConvertLinks()
	" Capture from the first non-space to the end.
	normal ^"ad$
	" Remove everthing remaining from the line.
	normal |d$

	let urls = matchlist(@a, "\\(http:\\/\\/[^ \\t\"']*\\)")
	if !empty(urls)
		" Get the URL that was found.
		let url = urls[1]
		" Remove the URL from the source string.
		let @a = substitute(@a, "http:\\/\\/[^ \\t\"']*", '', 'g')
		" Replace double spaces with single spaces.
		let @a = substitute(@a, '  ', ' ', 'g')
		" Remove trailing space.
		let @a = substitute(@a, '[ \t]*$', '', '')

		" Concatenate our new URL and place it into the register.
		let @a = '<a href="' . url . '">' . @a . '</a>'
		" Put the register.
		normal "ap
	endif
endfun

fun! FixHTMLEntities()
	%s/&#\d*\( \|[a-zA-Z]\)\@=/&;/g
endfun

function! VarExistsVal(var, val)
	if exists(a:var) | return a:val | else | return '' | endif
endfunction

function! VarExists(var)
	if exists(a:var) | return eval(a:var) | else | return '' | endif
endfunction

augroup VCSCommand
	au VCSCommand User VCSBufferCreated silent! normal 13_
augroup END

fun! CreateInserts()
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

vmap gl :<C-U>!svn blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>
