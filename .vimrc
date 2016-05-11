call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'conradirwin/vim-bracketed-paste'
Plug 'elzr/vim-json'
Plug 'fatih/vim-go'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'StanAngeloff/php.vim'
Plug 'tpope/vim-fugitive'

call plug#end()

let mapleader = " "

:set mouse=a

" file explorer
map <Leader>n :NERDTreeTabsToggle<CR>
:hi Directory guifg=#FF0000 ctermfg=red " Directory color

:set number " show line numbers

" status bar
let g:airline_theme='bubblegum'
let g:airline_powerline_fonts = 1 " https://github.com/vim-airline/vim-airline/issues/451
set laststatus=2 " https://github.com/vim-airline/vim-airline/issues/130
set ttimeoutlen=50

" detect *.md files as markdown
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
