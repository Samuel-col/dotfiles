so ~/.vim/plugins.vim

set nu rnu
set showbreak=→→→
set linebreak
set textwidth=100000
set showmatch	
set visualbell
set mouse=a

set hlsearch
set smartcase	
set incsearch	
 
set autoindent	
set shiftwidth=4	
set smartindent	
set smarttab	
set softtabstop=4	
"colorscheme slate
 
set confirm
set ruler	
set showtabline=2 
syntax on

set undolevels=1000	
set backspace=indent,eol,start	
nnoremap ñ :
inoremap kj <Esc>

let g:airline_theme='luna'
"let g:airline_theme='gruvbox'
"julia-vim
runtime macros/matching.vim
