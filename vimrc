" share ~/.vimrc between vim and neovim without a neovim config file
" put this into .profile
" export VIMINIT='let $MYVIMRC="$HOME/.vimrc" | source $MYVIMRC'
" map to open ~/.vimrc file in a split
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
set number
nnoremap <silent> <F2> :set nonumber!<CR>
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

set laststatus=2 "always show statusline
set statusline=
set statusline+=\ %n "buffer number
set statusline+=\ %F "full path to the file in the buffer
set statusline+=\ %m "modified
set statusline+=\ %r "read only flag
set statusline+=\ \Total=\%L "number of lines in buffer

" Enabling filetype support provides filetype-specific indenting,
" syntax highlighting, omni-completion and other useful settings.
filetype plugin indent on
syntax on

set autoindent                 " Minimal automatic indenting for any filetype.
set backspace=indent,eol,start " Intuitive backspace behavior.
"set hidden                     " Possibility to have more than one unsaved buffers.
set incsearch                  " Incremental search, hit `<CR>` to stop.

set hlsearch " Highlight search results for VIM

" netrw
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_liststyle = 3
"let g:netrw_browse_split = 4
"always change pwd while browsing around with netrw
let g:netrw_keepdir = 0
" start netrw if no arguments with vim/nvim at startup:
augroup ProjectDrawer
    autocmd!
    autocmd VimEnter * if argc() == 0 | Lexplore | endif
augroup END

" изменение размеров окон стрелками:
nnoremap <Up>    :resize +2<CR>
nnoremap <Down>  :resize -2<CR>
nnoremap <Left>  :vertical resize -2<CR>
nnoremap <Right> :vertical resize +2<CR>

" Navigate windows with <Ctrl-hjkl> instead of <Ctrl-w> followed by hjkl.
noremap <c-h> <c-w><c-h>
noremap <c-j> <c-w><c-j>
noremap <c-k> <c-w><c-k>
"noremap <c-l> <c-w><c-l>
noremap <c-l> :wincmd l<CR>

" закрытие буфера с сохранением окна
nnoremap <silent> <Leader>c :bp<BAR>bd#<CR>
nnoremap <F10> :qa<CR>

