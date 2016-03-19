call plug#begin('~/.vim/plugged')

Plug 'elzr/vim-json'
Plug 'fatih/vim-go'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'StanAngeloff/php.vim'
Plug 'tpope/vim-fugitive'

call plug#end()

let mapleader = " "

:set mouse=a

map <Leader>n :NERDTreeTabsToggle<CR>

:set number

:hi Directory guifg=#FF0000 ctermfg=red " Directory color
