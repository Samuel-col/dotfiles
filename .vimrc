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
 
set shiftwidth=4	
"set smartindent	
set smarttab	
set softtabstop=4	
set noautoindent	
set nosmartindent
filetype indent off
colorscheme slate
 
set confirm
set ruler	
set showtabline=2 
syntax on

set undolevels=1000	
set backspace=indent,eol,start	
"set foldmethod=indent
"set foldlevel=99
nnoremap ñ :
inoremap kj <Esc>
"nnoremap <space> za

let R_openhtml=0
let g:airline_theme='luna'
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_general_viewer = 'zathura'
"let g:airline_theme='gruvbox'
"julia-vim
runtime macros/matching.vim


"JULIA
tnoremap <Esc> <C-\><C-n>
nnoremap <C-j> ':vsplit term://julia'
