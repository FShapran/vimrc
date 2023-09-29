" todo назачить <space>2...для открытия файлов по номеру окна
" share ~/.vimrc between vim and neovim without a neovim config file
" put this into .profile
" export VIMINIT='let $MYVIMRC="$HOME/.vimrc" | source $MYVIMRC'
" map to open ~/.vimrc file in a split
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
" set number by <F2> to all files except netrw
autocmd FileType * if &ft != 'netrw' | nnoremap <F2> :set nonumber!<CR> | endif
autocmd BufEnter * if &ft == 'netrw' | nmap <buffer> <F2> <Nop> | endif

set background=light "for neovim
set mouse=a  " enable mouse

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight Cursorline and Number
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set cursorline only in the current window
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

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

" 7=Grey,8=DarkGrey
highlight LineNr     term=bold cterm=NONE ctermbg=7 ctermfg=DarkGrey
highlight CursorLineNr term=bold cterm=NONE ctermbg=7 ctermfg=1* "1* = Red
highlight CursorLine term=bold cterm=NONE ctermbg=7 ctermfg=NONE
highlight Visual     term=bold cterm=NONE ctermbg=8 ctermfg=NONE
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

" Current Window Statusline
highlight Statusline term=bold cterm=NONE ctermbg=Green ctermfg=white
" Another Window Statusline
highlight StatusLineNC term=bold cterm=NONE ctermbg=248 ctermfg=8

"Function: return window number: I use it for statusline
"abort -> function will abort soon as error detected
function! CurrWin() abort
  let l:current_win = winnr()
  return l:current_win
endfunction

"Function: return the permissions for an existing file
augroup Get_file_perm
	autocmd!
	autocmd BufWinEnter,FileChangedShell * let w:file_perm=getfperm(expand('%:p'))
augroup END
"Output, e.g. rw-rw-r--

" ...
let w:file_perm=<sid>Get_file_perm()
" ...
function! s:Get_file_perm() abort
  let a=getfperm(expand('%:p'))
  if strlen(a)
    return a
  else
     let b=printf("%o", xor(0777,system("umask")))
     let c=""
     for d in [0, 1, 2]
       let c.=and(b[d], 4) ? "r" : "-"
       let c.=and(b[d], 2) ? "w" : "-"
       let c.=and(b[d], 1) ? "x" : "-"
     endfor
     return c
   endif
 endfunction

set laststatus=2 "always show statusline
set statusline=
" set statusline+=%{ChangeStatuslineColor()}               " Changing the statusline color
set statusline+=\ " small indent
set statusline+=\ %{toupper(g:currentmode[mode()])}   " Current mode
set statusline+=\ \[W:\%{CurrWin()}\]
set statusline+=\ %F "full path to the file in the buffer
set statusline+=\ %y "full path to the file in the buffer
set statusline+=\ %m "modified
set statusline+=\ %r "read only flag
set statusline+=\ %c "Column number (byte index)
set statusline+=\:\%l "line number
set statusline+=\[\%L\]\ "number of lines in buffer
"set statusline+=\ %{w:file_perm}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VertSplit
highlight VertSplit term=bold cterm=NONE ctermbg=15 ctermfg=8
set fillchars+=vert:\▏" not need for nvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enabling filetype support provides filetype-specific indenting,
" syntax highlighting, omni-completion and other useful settings.
filetype plugin indent on
filetype plugin on "это сам добавил сомневаясь в предыдущем
syntax on

set autoindent                 " Minimal automatic indenting for any filetype.
set smartindent		" Mayby it would be useful for Python 20230929
set backspace=indent,eol,start " Intuitive backspace behavior.
"set hidden                     " Possibility to have more than one unsaved buffers.

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Search
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set incsearch                  " Incremental search, hit `<CR>` to stop.

set hlsearch " Highlight search results for VIM
" but not when soursing .vimrc
let @/ = ""
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
" Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Show all local changes in vim file before :w
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()
" following command to show changes before saving buffer
":DiffSaved 
