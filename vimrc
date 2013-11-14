" Don't be compatible with vi.
set nocompatible
filetype off

let vundle_autoinstall = 0
let vundle_readme = expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
    echo "Installing Vundle..."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
    let vundle_autoinstall = 1
endif

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Vundle manages Vundle. Vundleception!
Bundle 'gmarik/vundle'

Bundle 'PeterRincker/vim-argumentative.git'
Bundle 'itchyny/lightline.vim'
Bundle 'Raimondi/delimitMate'
Bundle 'sjl/gundo.vim'
Bundle 'osyo-manga/vim-over'
Bundle 'ervandew/supertab'

" A whole collection of language support files.
Bundle 'sheerun/vim-polyglot'
Bundle 'StanAngeloff/php.vim'

" My own stuff.
Bundle 'git@github.com:aaronbieber/quicktask.git'
Bundle 'git@github.com:aaronbieber/vim-committed.git'

" Nyan cat is critical.
Bundle 'koron/nyancat-vim'

" Tim Pope FTW.
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-unimpaired'

" Scrooloose FTW.
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'

" Colors
Bundle 'altercation/vim-colors-solarized'
Bundle 'ciaranm/inkpot'

" Syntaxes and language support
Bundle 'pangloss/vim-javascript'
Bundle 'tangledhelix/vim-octopress'
" This plug-in is huge and causes errors during BundleInstall, but it's the
" de-facto standard for LaTeX so I'm leaving it here as a reminder for the
" day I want to edit LaTeX, which is not uncommon for me at all.
" Bundle 'vim-scripts/LaTeX-Suite-aka-Vim-LaTeX'

" Helpers
Bundle 'godlygeek/tabular'
Bundle 'kien/ctrlp.vim'
Bundle 'majutsushi/tagbar'
Bundle 'mattn/emmet-vim'
Bundle 'mhinz/vim-signify'
Bundle 'SirVer/ultisnips'

if vundle_autoinstall
    echo "Installing bundles..."
    echo ""
    :BundleInstall
endif

if &termencoding == ""
    let &termencoding = &encoding
endif
set encoding=utf-8

" #############################################################################
" #                 Bootstrap my configuration and plugins                    #
" #############################################################################

" Fix the Solarized mapping.
call togglebg#map("")

" Now enable syntax highlighting and filetype stuff.
syntax on

" Enable filetype handling.
filetype plugin indent on

" Now process all of the configuration files that I have stored in my 'config'
" directory, which significantly cleans up this file.
for filename in sort(split(glob('~/.vim/config/*.vim'), '\n'))
    execute 'source '.filename
endfor

" vim: set et ts=4 sw=4 :
