color desert
set nu
set autowrite
set nobackup
set modeline
set nocompatible   " Disable vi-compatibility
"set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show Unicode glyphs
set t_Co=256 " Explicitly tell Vim that the terminal supports 256 colors

"set transparency=5
" start gvim without right and Left scrollbar

"
if has("cscope")
  set cscopequickfix=s-,g-,c-,d-,t-,e-,f-,i-
  if filereadable("cscope.out")
      cs add ./cscope.out
  endif
  set csverb
endif

if filereadable("tags")
  set tags=./tags; 
endif

set autochdir
set autoread "auto load after modified
set tabstop=4                " 设置Tab键的宽度        [等同的空格个数]  
set shiftwidth=4  
" Use file type plugins

set hidden
set wrap          " wrap lines
set expandtab     " expand tab to spaces
"set backspace=indent,eol,start
" allow backspacing over everything in insert mode
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set number        " always show line numbers
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis
"set ignorecase    " ignore case when searching
"set smartcase     " ignore case if search pattern is all lowercase,
                  "    case-sensitive otherwise
"set smarttab      " insert tabs on the start of a line according to
                  "    shiftwidth, not tabstop
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type
set updatecount=100 " every 100 chars will vim save them to swap
set cursorline    " Highlight the cursor line

" Set vim to have a large undo buffer
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set visualbell           " don't beep
set noerrorbells         " don't beep


" Use file type plugins
filetype plugin indent on
"autocmd filetype python set expandtab

"nnoremap j gj
"nnoremap k gk

" 快捷键间隔时间
" set timeoutlen=150

" Bind paste mode toggle to <Leader>p
"set pastetoggle=<leader>p


set encoding=utf-8 fileencodings=ucs-bom,utf-8,cp936

"Ctags 索引配置
nmap <leader>rr :!ctags --extra=+f --exclude=.git --exclude=log -R *
