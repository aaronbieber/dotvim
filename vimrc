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

" Lightline is a nice alternative to Powerline.
Bundle 'itchyny/lightline.vim'

" A whole collection of language support files.
Bundle 'sheerun/vim-polyglot'
Bundle 'StanAngeloff/php.vim'

" My own stuff.
Bundle 'git@github.com:aaronbieber/quicktask.git'

" Nyan cat is critical.
Bundle 'koron/nyancat-vim'

" Tim Pope FTW.
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-vinegar'

" Scrooloose FTW.
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'

" Colors
Bundle 'ciaranm/inkpot'
Bundle 'MaxSt/FlatColor'
Bundle 'w0ng/vim-hybrid'
Bundle 'sjl/badwolf'
Bundle 'shawncplus/skittles_berry'
Bundle 'Lokaltog/vim-distinguished'
Bundle 'blackgate/tropikos-vim-theme'

" Syntaxes and language support
Bundle 'pangloss/vim-javascript'
Bundle 'tangledhelix/vim-octopress'
" This plug-in is huge and causes errors during BundleInstall, but it's the
" de-facto standard for LaTeX so I'm leaving it here as a reminder for the
" day I want to edit LaTeX, which is not uncommon for me at all.
" Bundle 'vim-scripts/LaTeX-Suite-aka-Vim-LaTeX'

" Helpers -- these use the direct call to vundle#config#bundle because the
" Bundle command thinks that the comments at the end are arguments. Woof.
call vundle#config#bundle('ervandew/supertab')            " One tab to rule them all.
call vundle#config#bundle('junegunn/vim-easy-align')      " Align things. Easily.
call vundle#config#bundle('kien/ctrlp.vim')               " Fuzzy finder like Sublime Text.
call vundle#config#bundle('majutsushi/tagbar')            " Display tags in a file and navigate.
call vundle#config#bundle('mattn/emmet-vim')              " Create HTML quickly.
call vundle#config#bundle('Raimondi/delimitMate')         " Type matching surrounds quickly.
call vundle#config#bundle('SirVer/ultisnips')             " Like snippets from TextMate.
call vundle#config#bundle('mileszs/ack.vim')              " Use ack directly from Vim.
call vundle#config#bundle('justinmk/vim-sneak')           " Sneak around by two-letter searches.
call vundle#config#bundle('Keithbsmiley/investigate.vim') " Look up language definitions.

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
