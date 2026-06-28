" General Settings
set nocompatible
set history=1000
set encoding=utf-8
set undolevels=1000

" UI
set ruler
set number
set nolist
set mouse=a
set wildmenu
set showmatch
set cursorline
set splitbelow
set splitright
set listchars=
set scrolloff=5
set laststatus=2
set colorcolumn=
set signcolumn=no
set numberwidth=1
set nocursorcolumn
set wildmode=longest:full,full

" Truecolor — neovim auto-detects and looks best with it always on
set termguicolors

" Disable common plugin-provided indent guide overlays
let g:indentLine_enabled = 0
let g:indent_blankline_enabled = 0

" Indentation
set expandtab
set tabstop=4
set autoindent
set shiftround
set smartindent
set shiftwidth=4
set softtabstop=4
set backspace=indent,eol,start

" Search
set hlsearch
set gdefault
set incsearch
set smartcase
set ignorecase
set inccommand=nosplit

" Files & Buffers
set hidden
set autoread
set nobackup
set undofile
set noswapfile
set nowritebackup

" Keep undo history between sessions
if has('persistent_undo')
	let s:undo_dir = expand('~/.local/share/nvim/undo')
	if !isdirectory(s:undo_dir)
		call mkdir(s:undo_dir, 'p', 0700)
	endif
	let &undodir = s:undo_dir
endif

" Use system clipboard when available
if has('clipboard')
	set clipboard=unnamedplus
endif

" Faster UI feedback
set updatetime=300
set timeoutlen=500

" Key Mappings
let mapleader = " "

" Clear search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bp :bprevious<CR>

" Save and quit shortcuts
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" Keep visual selection when shifting indentation
vnoremap < <gv
vnoremap > >gv

" Enhancements
set confirm
set lazyredraw
set wildignorecase
set shortmess-=S
set foldmethod=indent
set foldlevelstart=99
set path+=**
set wildignore+=*/node_modules/*,*/.git/*,*/dist/*,*/__pycache__/*,*.pyc,*.o

" Built-in netrw file explorer
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_winsize=25
let g:netrw_browse_split=0

" Toggle the file explorer
nnoremap <leader>e :Lexplore<CR>
" Fuzzy file find — type a name then <Tab>/<CR> (rhs ends in a space, no inline comment)
nnoremap <leader>f :find<Space>
" List buffers and jump to one
nnoremap <leader>b :ls<CR>:b<Space>
" Toggle relative line numbers (off by default, preserves the minimal gutter)
nnoremap <leader>rn :set relativenumber!<CR>
" Strip trailing whitespace, keep cursor/view
nnoremap <leader>s :let b:_w=winsaveview()<Bar>keeppatterns %s/\s\+$//e<Bar>call winrestview(b:_w)<CR>
" Insert the current file's directory on the command line
cnoremap %% <C-r>=expand('%:h').'/'<CR>

" Keep search matches centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zz
nnoremap # #zz

" Reopen a file at the last cursor position
augroup LastPosition
	autocmd!
	autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
augroup END

" Highlight trailing whitespace (group colored in the theme block)
augroup TrailingWhitespace
	autocmd!
	autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
	autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
	autocmd InsertLeave * match ExtraWhitespace /\s\+$/
	autocmd BufWinLeave * call clearmatches()
augroup END

" Syntax & Colors
syntax on
set background=dark
filetype plugin indent on

" Make line-number gutter dark gray so it stands apart from code
augroup LineNumberColors
	autocmd!
	autocmd ColorScheme * highlight LineNr ctermfg=242 ctermbg=235 guifg=#6c6c6c guibg=#1f1f1f
	autocmd ColorScheme * highlight CursorLineNr ctermfg=177 ctermbg=235 guifg=#d787ff guibg=#1f1f1f cterm=bold gui=bold
	autocmd ColorScheme * highlight SignColumn ctermbg=235 guibg=#1f1f1f
augroup END
highlight LineNr ctermfg=242 ctermbg=235 guifg=#6c6c6c guibg=#1f1f1f
highlight CursorLineNr ctermfg=177 ctermbg=235 guifg=#d787ff guibg=#1f1f1f cterm=bold gui=bold
highlight SignColumn ctermbg=235 guibg=#1f1f1f

" Purple accent theme — chrome only (gutter/cursorline/search/menus/splits/folds)
augroup PurpleTheme
	autocmd!
	autocmd ColorScheme * highlight CursorLine      cterm=NONE ctermbg=237 guibg=#2a2440
	autocmd ColorScheme * highlight Visual          ctermbg=54  guibg=#3a2a5a
	autocmd ColorScheme * highlight Search          ctermfg=235 ctermbg=141 guifg=#1f1f1f guibg=#af87ff cterm=NONE gui=NONE
	autocmd ColorScheme * highlight IncSearch       ctermfg=235 ctermbg=177 guifg=#1f1f1f guibg=#d787ff cterm=bold gui=bold
	autocmd ColorScheme * highlight MatchParen      ctermfg=177 ctermbg=237 guifg=#d787ff guibg=#3a2a5a cterm=bold gui=bold
	autocmd ColorScheme * highlight Pmenu           ctermfg=189 ctermbg=237 guifg=#d7d7ff guibg=#2a2440
	autocmd ColorScheme * highlight PmenuSel        ctermfg=231 ctermbg=55  guifg=#ffffff guibg=#5f00af cterm=bold gui=bold
	autocmd ColorScheme * highlight PmenuThumb      ctermbg=141 guibg=#af87ff
	autocmd ColorScheme * highlight VertSplit       ctermfg=141 ctermbg=235 guifg=#af87ff guibg=#1f1f1f
	autocmd ColorScheme * highlight Folded          ctermfg=141 ctermbg=237 guifg=#af87ff guibg=#2a2440
	autocmd ColorScheme * highlight WildMenu        ctermfg=231 ctermbg=55  guifg=#ffffff guibg=#5f00af cterm=bold gui=bold
	autocmd ColorScheme * highlight ExtraWhitespace ctermbg=177 guibg=#d787ff
augroup END
highlight CursorLine      cterm=NONE ctermbg=237 guibg=#2a2440
highlight Visual          ctermbg=54  guibg=#3a2a5a
highlight Search          ctermfg=235 ctermbg=141 guifg=#1f1f1f guibg=#af87ff cterm=NONE gui=NONE
highlight IncSearch       ctermfg=235 ctermbg=177 guifg=#1f1f1f guibg=#d787ff cterm=bold gui=bold
highlight MatchParen      ctermfg=177 ctermbg=237 guifg=#d787ff guibg=#3a2a5a cterm=bold gui=bold
highlight Pmenu           ctermfg=189 ctermbg=237 guifg=#d7d7ff guibg=#2a2440
highlight PmenuSel        ctermfg=231 ctermbg=55  guifg=#ffffff guibg=#5f00af cterm=bold gui=bold
highlight PmenuThumb      ctermbg=141 guibg=#af87ff
highlight VertSplit       ctermfg=141 ctermbg=235 guifg=#af87ff guibg=#1f1f1f
highlight Folded          ctermfg=141 ctermbg=237 guifg=#af87ff guibg=#2a2440
highlight WildMenu        ctermfg=231 ctermbg=55  guifg=#ffffff guibg=#5f00af cterm=bold gui=bold
highlight ExtraWhitespace ctermbg=177 guibg=#d787ff

" Keep guide columns off, even after themes/filetypes re-apply defaults
augroup DisableGuideColumns
	autocmd!
	autocmd ColorScheme * highlight ColorColumn ctermbg=NONE guibg=NONE
	autocmd ColorScheme * highlight CursorColumn ctermbg=NONE guibg=NONE
	autocmd FileType * setlocal colorcolumn= nocursorcolumn nolist listchars=
	autocmd BufEnter * setlocal colorcolumn= nocursorcolumn
augroup END
highlight ColorColumn ctermbg=NONE guibg=NONE
highlight CursorColumn ctermbg=NONE guibg=NONE

" Enforce 4-space indentation in every buffer/filetype
augroup ForceFourSpaceIndent
	autocmd!
	autocmd FileType * setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
augroup END

" Purple statusline
augroup PurpleStatusline
	autocmd!
	autocmd ColorScheme * highlight StatusLine   ctermfg=189 ctermbg=237 guifg=#d7d7ff guibg=#2a2440 cterm=bold gui=bold
	autocmd ColorScheme * highlight StatusLineNC ctermfg=242 ctermbg=235 guifg=#6c6c6c guibg=#1f1f1f cterm=NONE gui=NONE
	autocmd ColorScheme * highlight StatusAccent ctermfg=235 ctermbg=141 guifg=#1f1f1f guibg=#af87ff cterm=bold gui=bold
augroup END
highlight StatusLine   ctermfg=189 ctermbg=237 guifg=#d7d7ff guibg=#2a2440 cterm=bold gui=bold
highlight StatusLineNC ctermfg=242 ctermbg=235 guifg=#6c6c6c guibg=#1f1f1f cterm=NONE gui=NONE
highlight StatusAccent ctermfg=235 ctermbg=141 guifg=#1f1f1f guibg=#af87ff cterm=bold gui=bold
set statusline=
set statusline+=%#StatusAccent#\ %f\ %#StatusLine#
set statusline+=\ %h%w%m%r
set statusline+=%=
set statusline+=\ %y\ %{&fileencoding!=#''?&fileencoding:&encoding}\
set statusline+=%#StatusAccent#\ %l:%c\ %p%%\
