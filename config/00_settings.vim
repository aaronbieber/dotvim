" ---------------------- Basic configuration settings ------------------------
set autoindent				" Maintain indent levels automatically.
set backspace=2				" Allow backspacing in basically every possible 
							" situation (the way I like it).
set foldcolumn=4			" Show a 4-column gutter to the left for 
							" folding characters.
set foldmethod=marker		" Fold on markers; {{{ and }}} by default.
set formatoptions=tqnw		" Auto-wrap by tw, allow 'gq', recognize lists, 
							" and trailing whitespace continues a paragraph.
set ignorecase smartcase	" Case insensitive search unless caps are used 
							" in search term.
set laststatus=2			" Always show the status line.
set textwidth=0				" By default, don't wrap at any specific 
							" column.
set linebreak wrap			" Wrap text while typing (this is a soft wrap 
							" without textwidth set).
set mouse=a					" Allow use of the mouse in all situations.
set nu						" Use line numbering.
set shiftwidth=4			" That means I like to indent by that amount as 
							" well.
set ts=4					" The best tab stop is 4.
set whichwrap=h,l,~,[,]		" These keys will move the cursor over line 
							" boundaries ('wrap').
set wildmenu				" Tab completion for files with horizontal list 
							" of choices.
set winminheight=0			" Allow window split borders to touch.
set scrolloff=5				" Don't let the cursor get fewer than 5 lines 
							" away from the edge whenever possible.
set modeline				" Always read modeline stuff from the bottom of 
							" files.
let mapleader=","			" Use comma instead of backslash as my map 
							" leader.

set incsearch				" Search incrementally (while typing).
set hidden					" Don't unload buffers that are abandoned; hide 
							" them.

" Don't create backup files when editing in these locations.
set backupskip=/tmp/*,/private/tmp/*

" Display unprintable characters in a particular way.
set list listchars=tab:›\ ,trail:-,extends:>,precedes:<,eol:¬

" Allow the html syntax file to recognize improper comments.
" Because I use them. Improperly.
let g:html_wrong_comments = 1

" A couple of environment variables for the spelling stuff.
let IspellLang = 'english'

" Use my own status line
set statusline=%<%f\ %h%m%r\ %=%20{BCFStatusLineElement()}%3{BCFStatusLineElementTicket()}%3{BCFStatusLineElementFileStatus()}\ %-14.(%l,%c%V%)\ %P 
