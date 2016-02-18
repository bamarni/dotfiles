call plug#begin('~/.vim/plugged')

Plug 'fatih/vim-go'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'StanAngeloff/php.vim'
Plug 'tpope/vim-fugitive'

call plug#end()

let mapleader = " "

map <Leader>n :NERDTreeTabsToggle<CR>

:hi Directory guifg=#FF0000 ctermfg=red " Directory color
