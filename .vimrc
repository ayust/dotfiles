" 256 colors and syntax highlighting
set t_Co=256
colorscheme xoria256
syntax on

" Keep things tidy
set redraw optimize

" Turn on line numbering...
set number
" And enable mouse support to prevent copying line numbers, etc
set mouse=a

" Use 'tabs are actually 4 spaces' and intelligent indenting
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

" Incremental search with intelligent case-sensitivity
set incsearch
set ignorecase smartcase

" Tab completion when in insert mode and not indenting
function! CleverTab()
  if strpart( getline('.'), col('.')-2, col('.')-1 ) =~ '^\s*$'
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
