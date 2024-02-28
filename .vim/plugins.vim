set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
let g:clang_c_options = '-std=gnu11'
Plugin 'VundleVim/Vundle.vim'

" (*) Aqui agregamos las líneas <Plugin> para incorporar nuevos plugins a Vim
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

Plugin 'scrooloose/nerdtree'
"Plugin 'sheerun/vim-polyglot'

Plugin 'lervag/vimtex'

Plugin 'jalvesaq/nvim-r'

"Plugin 'JuliaEditorSupport/julia-vim'
"Plugin 'kdheepak/JuliaFormatter.vim'
Plugin 'jpalardy/vim-slime'
Plugin 'JuliaLang/julia-vim'
Plugin 'tmhedberg/matchit'
"Plugin 'neoclide/coc.nvim'
"Plugin 'fannheyward/coc-julia'

Plugin 'xolox/vim-misc'

Plugin 'honza/vim-snippets'
"Plugin 'github/copilot.vim'
"Plugin 'roxma/nvim-completion-manager'
"Plugin 'ycm-core/YouCompleteMe'
Plugin 'suan/vim-instant-markdown'
"Plugin 'phanviet/vim-monokai-pro'
"Plugin 'kannokanno/previm'
Plugin 'SirVer/ultisnips'
"Plugin 'https://github.com/honza/vim-snippets/tree/master/snippets'
"Plugin 'https://github.com/xolox/vim-lua-ftplugin'

call vundle#end()
filetype plugin indent off
