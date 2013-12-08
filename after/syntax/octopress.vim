" Octopress syntax extensions to accommodate my own new Octopress tags.
" Aaron Bieber, 2013
"
" The octopressExtendedLiquidBlock matches Liquid template blocks for new 
" Liquid tags that I have created, such as the infobox.
syn region octopressExtendedLiquidBlock matchgroup=octopressExtendedLiquidBlockDelimiter start=/\m{%\s\+\(infobox\)\+\s.*\s*%}/ end=/\m{%\s\+end\(infobox\)\+\s\+%}/


" Link the regions and matches to highlight groups.
hi def link  octopressExtendedLiquidBlockDelimiter   PreProc
