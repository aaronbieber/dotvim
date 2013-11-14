Installation
============

Just clone this repository into the appropriate local Vim configuration 
location for your platform and then create symlinks or source the 
configurations from there into your home directory.

For Linux / Mac OS X
--------------------

Clone the repository into your local `.vim` directory:

	git clone https://github.com/aaronbieber/dotvim ~/.vim

Create symlinks for Vim < 7.4:

	ln -s ~/.vim/vimrc ~/.vimrc
	ln -s ~/.vim/gvimrc ~/.gvimrc

For Windows
-----------

I used to use gVim full-time in Windows and maintained compatibility with 
Windows in all of these configuration files. That is no longer the case and 
therefore Windows compatibility is most assuredly *not* guaranteed. In fact, 
I'm pretty confident it won't work at all (because the configuration file glob 
only matches `~/.vim/` and will not find e.g. `C:\vim\vimfiles`).

Bundle with Vundle!
-------------------

Provided that git is installed and in your path, Vundle will automatically be 
cloned into `~/.vim/bundle/vundle` and bundles will be installed on the first 
run, so brace yourself.

That's it!
