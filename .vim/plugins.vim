set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
let g:clang_c_options = '-std=gnu11'
Plugin 'VundleVim/Vundle.vim'

" (*) Aqui agregamos las líneas <Plugin> para incorporar nuevos plugins a Vim
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'https://github.com/scrooloose/nerdtree'
"Plugin 'goballooning/LaTeX-Box'
Plugin 'sheerun/vim-polyglot'
"Plugin 'LaTeX-Box-Team/LaTeX-Box'
Plugin 'lervag/vimtex'
"Plugin 'ycm-core/YouCompleteMe'
Plugin 'jalvesaq/nvim-r'
"Plugin 'JuliaEditorSupport/julia-vim'
Plugin 'JuliaLang/julia-vim'
Plugin 'tmhedberg/matchit'
"Plugin 'roxma/nvim-completion-manager'
"Plugin 'gaalcaras/ncm-R'
"Plugin 'morhetz/gruvbox'
"Plugin 'isnowfy/python-vim-instant-markdown'
Plugin 'suan/vim-instant-markdown'
"Plugin 'phanviet/vim-monokai-pro'
"Plugin 'sheerun/vim-polyglot'
"Plugin 'kannokanno/previm'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
"https://github.com/honza/vim-snippets/tree/master/snippets
Plugin 'xolox/vim-misc'
Plugin 'https://github.com/xolox/vim-lua-ftplugin'

call vundle#end() " required
filetype plugin indent on " required
