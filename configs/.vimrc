" Basic Vim Configuration with Go support
set nocompatible
filetype off

" Install vim-plug if not already installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/plugged')

" Go development
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" File management
Plug 'preservim/nerdtree'

" Git integration
Plug 'tpope/vim-fugitive'

" Auto completion
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --go-completer' }

" Syntax highlighting
Plug 'sheerun/vim-polyglot'

" Status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

" Basic settings
set number
set relativenumber
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent
set hlsearch
set incsearch
set ignorecase
set smartcase
set wildmenu
set wildmode=list:longest
set scrolloff=8
set sidescrolloff=8
set mouse=a
set clipboard=unnamed
set encoding=utf-8
set fileencoding=utf-8
set backspace=indent,eol,start
set splitbelow
set splitright

" Color scheme
syntax enable
set background=dark
colorscheme default

" Go specific settings
au FileType go set noexpandtab
au FileType go set shiftwidth=4
au FileType go set softtabstop=4
au FileType go set tabstop=4

" Go shortcuts
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)

" NERDTree settings
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" Key mappings
let mapleader = ","
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>

" Split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Clear search highlighting
nnoremap <silent> <leader>/ :nohlsearch<CR>

" Show whitespace
set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list

" Auto-reload files changed outside vim
set autoread

" Persistent undo
set undofile
