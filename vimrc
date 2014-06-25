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
call vundle#begin()

" Vundle manages Vundle. Vundleception!
Plugin 'gmarik/vundle'

" Lightline is a nice alternative to Powerline.
Plugin 'itchyny/lightline.vim'

" A whole collection of language support files.
Plugin 'sheerun/vim-polyglot'
Plugin 'StanAngeloff/php.vim'

" My own stuff.
Plugin 'git@github.com:aaronbieber/vim-quicktask.git'
Plugin 'git@github.com:aaronbieber/vim-vault.git'

" Nyan cat is critical.
Plugin 'koron/nyancat-vim'

" Tim Pope FTW.
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-vinegar'
Plugin 'tpope/vim-obsession'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-scriptease'

" Scrooloose FTW.
Plugin 'scrooloose/syntastic'

" Helpers.
Plugin 'jeetsukumaran/vim-gazetteer'
Plugin 'Keithbsmiley/investigate.vim'
Plugin 'SirVer/ultisnips'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'ervandew/supertab'
Plugin 'gcmt/wildfire.vim'
Plugin 'honza/vim-snippets'
Plugin 'jiangmiao/auto-pairs'
Plugin 'junegunn/vim-easy-align'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'vim-php/tagbar-phpctags.vim'
Plugin 'mattn/emmet-vim'
Plugin 'mileszs/ack.vim'
Plugin 'rking/ag.vim'
Plugin 'tacahiroy/ctrlp-funky'
Plugin 'terryma/vim-multiple-cursors'

" This plug-in is huge and causes errors during BundleInstall, but it's the
" de-facto standard for LaTeX so I'm leaving it here as a reminder for the
" day I want to edit LaTeX, which is not uncommon for me at all.
" Bundle 'vim-scripts/LaTeX-Suite-aka-Vim-LaTeX'

call vundle#end()

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
