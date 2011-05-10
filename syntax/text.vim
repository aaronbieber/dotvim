" Vim syntax file
" Language:         Text (plain text)
" Maintainer:       Aaron Bieber
" Latest Revision:  2010-07-13

"if exists("b:current_syntax")
"  finish
"endif

let s:cpo_save = &cpo
set cpo&vim

syn match		textHeading		'^[ \t]*[A-Z0-9][^a-z]*$'
syn match		textEmphasis    /\W_[^_]\+_\W/
syn match		textBold        /\*[^*]\+\*/

hi def link textHeading			Title
hi def textEmphasis term=underline cterm=underline gui=italic
hi def textBold term=bold cterm=bold gui=bold

let b:current_syntax = "text"

let &cpo = s:cpo_save
unlet s:cpo_save
