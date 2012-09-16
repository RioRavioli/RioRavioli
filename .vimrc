"//use add.cpp
set number
set showmode

set ignorecase
set smartcase
set incsearch
"set hlsearch

set laststatus=2
set showmatch
set tabstop=3
set shiftwidth=3

nmap <C-O> o<Esc>x
map <F2> :w<Enter>
map <F3> :call Compile()<Enter>
"map <F4> :!./%<<Enter>
map <F4> :call Run()<Enter>
imap ,, ""<Space>+<Esc>hhi

:filetype plugin on
:syntax enable
:filetype plugin indent on

fun! Run()
	if &filetype == 'ruby'
		:!ruby %<.rb
	elseif &filetype == 'python'
		:!python2 %<.py	
	elseif &filetype == 'java'
		:!java %<
	else
		:!./%<
	endif
endfun

fun! Compile()
	if &filetype == 'c'
		:!gcc -std=c99 -Wall -o %< %
	elseif &filetype == 'cpp'
		if strpart(getline(1), 0, 5) == '//use'
			let files = strpart(getline(1), 5)
			let files = ':!g++ -Wall -o %< %' . files
		else
			let files = ':!g++ -Wall -o %< %'
		endif
		:exe files
	elseif &filetype == 'java'
		:!javac %<.java
	else
		:!echo "invalid filetype"
	endif
endfun

