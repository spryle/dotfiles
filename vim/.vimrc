set nocompatible
filetype off

" setup and run vundle
set rtp+=~/.vim/bundle/vundle/
set rtp+=~/.local/lib/python2.7/site-packages/powerline/bindings/vim/
call vundle#begin()

Plugin 'gmarik/Vundle'

Plugin 'scrooloose/syntastic'
Plugin 'kien/ctrlp.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'rizzatti/funcoo.vim'
Plugin 'rizzatti/dash.vim'

Plugin 'saltstack/salt-vim'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'django.vim'
Plugin 'python.vim'
Plugin 'nginx.vim'
Plugin 'mxw/vim-jsx'

" Use Vim defaults (much better!)
set nocompatible

set encoding=utf-8

" load indentation rules and plugins
" according to the detected filetype.
filetype plugin on
filetype plugin indent on
syntax on

set number

" Always show statusline
set laststatus=2

" Tab/Indent Settings
set autoindent
set nosmartindent
set backspace=indent,eol,start
set smarttab
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

"Always show current position
" set ruler

" Don't redraw while executing macros (good performance config)
set lazyredraw

autocmd BufRead,BufNewFile,FileReadPost *.sls set filetype=sls
autocmd BufRead,BufNewFile,FileReadPost *.py set filetype=python
autocmd BufRead,BufNewFile,FileReadPost *.html set filetype=htmldjango

" Omnicomplete
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" Text Width & Wrapping Settings
set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=80

highlight ColorColumn guibg=#cccccc ctermbg=darkgray
highlight Folded ctermfg=6 ctermbg=0

" keep 50 lines of command line history
set history=50

" Show (partial) command in status line.
set showcmd

" Show matching brackets.
set showmatch

" Set to not auto read when a file is changed from the outside
set noautoread

" Don't automatically save before commands like :next and :make
set noautowrite

" Don't make buffers hidden when abandoned
set nohid

" Ignore compiled files
set wildignore=*.o,*.so,*.swo,*.swp,*.pyc,*.pyo,*~

" No case insensitive matching
set noignorecase

" Turn of smart case matching
set nosmartcase

" Incremental search
set noincsearch

" Highlight search results
set hlsearch

" Apply substitutions to all lines by default
set nogdefault

" Enable mouse usage (all modes)
" set mouse=a

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Turn on the WiLd menu
set wildmenu

if &t_Co > 2 || has("gui_running")
  set t_Co=256
  colorscheme railscasts
endif

let g:jsx_ext_required = 0 " Allow JSX in normal JS files

" - syntastic
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1
let g:syntastic_python_checker = "flake8"
let g:syntastic_javascript_checkers = ['eslint']

" Source a local configuration file if available
if filereadable("~/.vimrc.local")
    source ~/.vimrc.local
endif
