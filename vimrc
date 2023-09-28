" todo назачить <space>2...для открытия файлов по номеру окна
" share ~/.vimrc between vim and neovim without a neovim config file
" put this into .profile
" export VIMINIT='let $MYVIMRC="$HOME/.vimrc" | source $MYVIMRC'
" map to open ~/.vimrc file in a split
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
set number
nnoremap <F2> :set nonumber!<CR>
set background=light "for neovim
set mouse=a  " enable mouse

" cursor shape for vim. It doesn't need for nvim:
if &term =~? 'rxvt' || &term =~? 'xterm' || &term =~? 'st-'
    " 1 or 0 -> blinking block
    " 2 -> solid block
    " 3 -> blinking underscore
    " 4 -> solid underscore
    " Recent versions of xterm (282 or above) also support
    " 5 -> blinking vertical bar
    " 6 -> solid vertical bar
    " Insert Mode
    let &t_SI .= "\<Esc>[6 q"
    " Normal Mode
    let &t_EI .= "\<Esc>[2 q"
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Statusline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:currentmode={
      \ 'n'  : 'N ',
      \ 'no' : 'N·Operator Pending ',
      \ 'v'  : 'V ',
      \ 'V'  : 'V·Line ',
      \ 'VB' : 'V·Block ',
      \ 's'  : 'Select ',
      \ 'S'  : 'S·Line ',
      \ '' : 'S·Block ',
      \ 'i'  : 'I ',
      \ 'R'  : 'R ',
      \ 'Rv' : 'V·Replace ',
      \ 'c'  : 'Command ',
      \ 'cv' : 'Vim Ex ',
      \ 'ce' : 'Ex ',
      \ 'r'  : 'Prompt ',
      \ 'rm' : 'More ',
      \ 'r?' : 'Confirm ',
      \ '!'  : 'Shell ',
      \ 't'  : 'Terminal '
      \}


" highlight User1 cterm=None gui=None ctermfg=007 guifg=fgcolor
" highlight User2 cterm=None gui=None ctermfg=008 guifg=bgcolor
" highlight User3 cterm=None gui=None ctermfg=008 guifg=bgcolor
" highlight User4 cterm=None gui=None ctermfg=008 guifg=bgcolor
" highlight User5 cterm=None gui=None ctermfg=008 guifg=bgcolor
" highlight User7 cterm=None gui=None ctermfg=008 guifg=bgcolor
" highlight User8 cterm=None gui=None ctermfg=008 guifg=bgcolor
" highlight User9 cterm=None gui=None ctermfg=007 guifg=fgcolor

" Automatically change the statusline color depending on mode
" не работает эта штука - цвет выбеляет один раз и всё...
function! ChangeStatuslineColor()
  if (mode() =~# '\v(n|no)')
    exe 'hi! StatusLine ctermfg=008 guifg=fgcolor gui=None cterm=None'
  elseif (mode() =~# '\v(v|V)' || g:currentmode[mode()] ==# 'V·Block' || get(g:currentmode, mode(), '') ==# 't')
    exe 'hi! StatusLine ctermfg=005 guifg=#00ff00 gui=None cterm=None'
  elseif (mode() ==# 'i')
    exe 'hi! StatusLine ctermfg=004 guifg=#6CBCE8 gui=None cterm=None'
  else
    exe 'hi! StatusLine ctermfg=006 guifg=orange gui=None cterm=None'
  endif

  return ''
endfunction

"Function: return window number: I use it for statusline
"abort -> function will abort soon as error detected
function! CurrWin() abort
  let l:current_win = winnr()
  return l:current_win
endfunction

set laststatus=2 "always show statusline
set statusline=
" set statusline+=%{ChangeStatuslineColor()}               " Changing the statusline color
set statusline+=%0*\ %{toupper(g:currentmode[mode()])}   " Current mode
set statusline+=\ \Win:\%{CurrWin()}
set statusline+=\ \BufN:\%n "buffer number
set statusline+=\ %F "full path to the file in the buffer
set statusline+=\ %m "modified
set statusline+=\ %r "read only flag
set statusline+=\ \Lines:\%L "number of lines in buffer

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enabling filetype support provides filetype-specific indenting,
" syntax highlighting, omni-completion and other useful settings.
filetype plugin indent on
syntax on

set autoindent                 " Minimal automatic indenting for any filetype.
set backspace=indent,eol,start " Intuitive backspace behavior.
"set hidden                     " Possibility to have more than one unsaved buffers.
set incsearch                  " Incremental search, hit `<CR>` to stop.

set hlsearch " Highlight search results for VIM
" turn off search highlight. Defaul is <c-l>
nnoremap <silent> ,<space> :nohlsearch<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indentation
"You can check where the indent options were set via
":verbose setlocal ts? sts? sw? et?
"You can check filetype
":set filetype
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Vim has 5 options relating to (manual) indentation:
"
"Name	    Shorthand	Default Value
"expandtab	    et	off
"tabstop        ts  8
"shiftwidth	    sw	8
"softtabstop	  sts	0
"smarttab	sta	  off (Neovim: on)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" by default, the indent is 2 spaces. 
" всё по отступать ещё нужно проверить:
set shiftwidth=2
set softtabstop=2
set tabstop=2

" for html files 2 spaces
autocmd Filetype html,json,yaml set ts=2 sw=2 expandtab
" for js 4 spaces
autocmd Filetype python,javascript set ts=4 sw=4 sts=4 expandtab

"au BufNewFile,BufRead *.py
"    \ set expandtab
"    \ set tabstop=4
"    \ set softtabstop=4
"    \ set shiftwidth=4
"au BufNewFile,BufRead *.js,*.html,*.css,*.json
"    \ set tabstop=2
"    \ set softtabstop=2
"    \ set shiftwidth=2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" netrw
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:netrw_banner = 0
let g:netrw_winsize = 15
let g:netrw_liststyle = 3
"let g:netrw_browse_split = 4
"always change pwd while browsing around with netrw
let g:netrw_keepdir = 0
" start netrw if no arguments with vim/nvim at startup:
augroup ProjectDrawer
    autocmd!
    autocmd VimEnter * if argc() == 0 | Lexplore | endif
augroup END
" open/close netrw:
nnoremap <silent> <F9> :Lex<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mapings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" изменение размеров окон стрелками:
nnoremap <Up>    :resize +2<CR>
nnoremap <Down>  :resize -2<CR>
nnoremap <Left>  :vertical resize -2<CR>
nnoremap <Right> :vertical resize +2<CR>

" Navigate windows with <Ctrl-hjkl> instead of <Ctrl-w> followed by hjkl.
noremap <c-h> <c-w><c-h>
noremap <c-j> <c-w><c-j>
noremap <c-k> <c-w><c-k>
noremap <c-l> <c-w><c-l>
" In insert or command mode, move normally by using Ctrl
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>

" Start scrolling slightly before the cursor reaches an edge
set scrolloff=5
set sidescrolloff=5

" закрытие буфера с сохранением окна
nnoremap <silent> <Leader>c :bp<BAR>bd#<CR>

nnoremap <silent> <F10> :qa<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" с этой помощью можно поизучать цвета
" highlight ColorColumn ctermbg=235 guibg=#2c2d27
" set colorcolumn=80
"
"
"
