call plug#begin('~/.vim/plugged')

" installing vim airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug '~/.fzf'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()

" ---------------
" UI
" ---------------
"set ruler          " Ruler on
set number         " Line numbers on
"set nowrap         " Line wrapping off
"set laststatus=2   " Always show the statusline
"set cmdheight=2    " Make the command area two lines high
"set cursorline     " Highlight current line
set encoding=utf-8
"set noshowmode     " Don't show the mode since Powerline shows it
set title           " Set the title of the window in the terminal to the file
set showcmd         " Show me what I'm typing
set autoindent      " Enabile Autoindent
set autoread        " Automatically read changed files
set expandtab       " Convert tab to spaces
set ts=2 sw=2 ai    " set tabstop =2 and shift width = 2 with auto indent
set tags=.tags      " set ctags

fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled=1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"

"Alias Wq to wq
command -complete=file -bang -nargs=? W  :w<bang> <args>
command -complete=file -bang -nargs=? Wq :wq<bang> <args>

