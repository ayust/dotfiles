""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                                            "
" Many things here stolen from http://amix.dk/vim/vimrc.html "
"                                                            "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" UTF-8 is the future
set encoding=utf8

" Default to unix EOLs, but handle others gracefully
set ffs=unix,dos,mac

" Don't try to redraw in the middle of a macro
set lazyredraw

" 256 colors and syntax highlighting
set t_Co=256
colorscheme xoria256
syntax on

" Turn on line numbering and position indicators...
set number numberwidth=6
set ruler
" And enable mouse support to prevent copying line numbers, etc
set mouse=a

" Use 'tabs are actually 4 spaces' and intelligent indenting
set tabstop=8
set softtabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent

" Make backspace work nicely
set backspace=indent,eol,start

" Incremental search with intelligent case-sensitivity
set incsearch
set ignorecase smartcase

" Tab completion when in insert mode and not indenting
function! CleverTab()
  if strpart( getline('.'), col('.')-2, 1 ) =~ '\s*'
    return "\<Tab>"
  else
    return "\<C-N>"
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>

" Modeline support
set modeline
set modelines=3

" File type detection
filetype on
filetype plugin on

" Ignore compiled files when completing paths
set wildignore=*.o,*~,*.pyc,*.pyo,*.class,*.hi


" KEYBINDINGS
""""""""""""""""""""""""""""""""""""""""""""""""""

" Unbind the arrow keys (old habits die hard)
noremap <left> <nop>
noremap <up> <nop>
noremap <down> <nop>
noremap <right> <nop>

" Bind jk/kj in insert to <esc> and then unbind <esc>
inoremap jk <esc>
inoremap kj <esc>


" Use the comma key for extra key combos
let mapleader = ","
let g:mapleader = ","

" ,m = remove carriage returns
noremap <leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" ,ss = toggle spell check
noremap <leader>ss :setlocal spell!<cr>


" ABBREVIATIONS (Mostly typo fixes)
""""""""""""""""""""""""""""""""""""""""""""""""""
iabbrev waht what
iabbrev adn and
iabbrev tehn then
iabbrev taht that
iabbrev tahn than


" TRIGGERED ACTIONS
""""""""""""""""""""""""""""""""""""""""""""""""""

" These are grouped to prevent duplication when sourcing
augroup vimrc
  autocmd!
  " Remember info about open buffers on close...
  set viminfo^=%
  " and return to last edit position when opening files
  autocmd BufReadPost *
       \ if line("'\"") > 0 && line("'\"") <= line("$") |
       \   exe "normal! g`\"" |
       \ endif

  " Delete trailing whitespace on save in .py files
  func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
  endfunc
  autocmd BufWrite *.py :call DeleteTrailingWS()

  " Automatically reload .vimrc when it is saved
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END


" GOOGLE-SPECIFIC FUNCTIONALITY
""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable("/usr/share/vim/google/google.vim")
  source /usr/share/vim/google/google.vim
endif
if filereadable("/usr/share/vim/google/gtags.vim")
  source /usr/share/vim/google/gtags.vim
  nnoremap <C-]> :call Gtag(expand('<cword>'))<CR>
endif
