let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename', 'commit-tracker' ] ]
      \ },
      \ 'component_function': {
      \   'modified': 'LLModified',
      \   'readonly': 'LLReadOnly',
      \   'fugitive': 'LLFugitive',
      \   'filename': 'LLFilename',
      \   'fileformat': 'LLFileFormat',
      \   'filetype': 'LLFileType',
      \   'fileencoding': 'LLFileEncoding',
      \   'mode': 'LLMode',
      \   'commit-tracker': 'LLCommitTracker'
      \ },
      \ 'separator': { 'left': '⮀', 'right': '⮂' },
      \ 'subseparator': { 'left': '⮁', 'right': '⮃' }
      \ }

function! LLCommitTracker()
    if !exists("*committed#status_line_symbol")
        return ''
    endif

    let line = committed#status_line_symbol() . ' ' . committed#status_line_filename()
    if len(line) > 1
        return line
    else
        return ''
    endif
endfunction

function! LLModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LLReadOnly()
  return &ft !~? 'help\|vimfiler\|gundo' && &ro ? '⭤' : ''
endfunction

function! LLFilename()
  return ('' != LLReadOnly() ? LLReadOnly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() : 
        \  &ft == 'unite' ? unite#get_status_string() : 
        \  &ft == 'vimshell' ? substitute(b:vimshell.current_dir,expand('~'),'~','') : 
        \ '' != expand('%t') ? expand('%t') : '[No Name]') .
        \ ('' != LLModified() ? ' ' . LLModified() : '')
endfunction

function! LLFugitive()
  return &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head') && strlen(fugitive#head()) ? '⭠ '.fugitive#head() : ''
endfunction

function! LLFileFormat()
  return winwidth('.') > 70 ? &fileformat : ''
endfunction

function! LLFileType()
  return winwidth('.') > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LLFileEncoding()
  return winwidth('.') > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LLMode()
  return winwidth('.') > 60 ? lightline#mode() : ''
endfunction

" vim: set et ts=4 sw=4 :
