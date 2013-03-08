syn region octopressGenericLiquidBlock matchgroup=octopressGenericLiquidBlockDelimiter start=/\m{%\s\+[a-z]\+\s.*\s*%}/ end=/\m{%\s\+end[a-z]\+\s\+%}/


hi def link  octopressGenericLiquidBlockDelimiter   PreProc
hi def link  octopressGenericLiquidBlock            Underlined
