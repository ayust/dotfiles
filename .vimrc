set t_Co=256
colorscheme xoria256
syntax on
set redraw optimize

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

set ignorecase smartcase
function! CleverTab()
  if strpart( getline('.'), col('.')-2, col('.')-1 ) =~ '^\s*$'
    return "\<Tab>"
  else
    return "\<C-N>"
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>

set modeline
set modelines=3
