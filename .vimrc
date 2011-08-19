set expandtab
set shiftwidth=2
set tabstop=2
" set shell=/bin/bash
set title
" set backupdir=~/.backup
" set directory=.,~/.backup,/tmp
set background=dark
set showmatch
set incsearch
colorscheme desert
"set cindent

"set bs=2 " fix backspace

set smartindent
set number

filetype plugin indent on
autocmd FileType python set complete+=k~/.vim/syntax/python.vim isk+=.,(
autocmd FileType python set tabstop=4
autocmd FileType python set shiftwidth=4
autocmd FileType python set softtabstop=4
autocmd FileType python set autoindent

"set ai                  " auto indenting
set history=100         " keep 100 lines of history
set ruler               " show the cursor position
syntax on               " syntax highlighting
set hlsearch            " highlight the last searched term
filetype plugin on      " use the file type plugins

" When editing a file, always jump to the last cursor position
autocmd BufReadPost *
\ if ! exists("g:leave_my_cursor_position_alone") |
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
\ exe "normal g'\"" |
\ endif |
\ endif

if has("gui_running")
  set guifont=Fixedsys\ Excelsior\ 3.01:h16
  set go-=T  " hide toolbar
  colorscheme railscasts
  set transparency=5
else
  colorscheme desert
endif
