" General Settings
set nocompatible    " Use Vim behavior instead of old vi compatibility mode
set history=1000    " Remember up to 1000 command-line entries
set encoding=utf-8  " Default text encoding
set undolevels=1000 " Keep 1000 undo changes in memory per buffer

" UI
set ruler                      " Show current cursor position
set number                     " Show absolute line number on current line
set nolist                     " Do not render whitespace marker characters
set mouse=a                    " Enable mouse in all modes
set wildmenu                   " Enhanced completion UI in command-line mode
set showmatch                  " Briefly jump to matching bracket/paren
set cursorline                 " Highlight the current line
set splitbelow                 " Horizontal splits open below current window
set splitright                 " Vertical splits open to the right
set listchars=                 " Clear any inherited whitespace marker config
set scrolloff=5                " Keep 5 lines visible above/below cursor
set laststatus=2               " Always display a status line
set colorcolumn=               " Disable vertical guide columns
set signcolumn=no              " Do not reserve the 2-character sign gutter
set numberwidth=1              " Minimize left padding in the number column
set nocursorcolumn             " Disable highlighted cursor column
set wildmode=longest:full,full " Completion behavior for Tab cycling

" Truecolor when the terminal advertises it (tmux passes Tc); cterm values below
" keep the purple accents working on plain 256-color terminals.
if has('termguicolors') && ($COLORTERM ==# 'truecolor' || $COLORTERM ==# '24bit')
	set termguicolors
endif

" Disable common plugin-provided indent guide overlays
let g:indentLine_enabled = 0
let g:indent_blankline_enabled = 0

" Indentation
set expandtab                  " Insert spaces instead of literal tab characters
set tabstop=4                  " Display a hard tab character as 4 spaces
set autoindent                 " Copy indentation from current line
set shiftround                 " Round indent operations to multiples of shiftwidth
set smartindent                " Smart auto-indenting for common code patterns
set shiftwidth=4               " Indent/outdent commands use 4 spaces
set softtabstop=4              " Tab/Backspace in insert mode act like 4 spaces
set backspace=indent,eol,start " Allow backspace over indent/eol/insert-start

" Search
set hlsearch   " Highlight all matches after a search
set gdefault   " :substitute uses global replacement by default
set incsearch  " Show matches while typing search pattern
set smartcase  " Switch to case-sensitive if pattern has uppercase
set ignorecase " Case-insensitive search by default

" Files & Buffers
set hidden        " Allow switching buffers with unsaved changes
set autoread      " Auto-reload file when changed outside Vim
set nobackup      " Do not create backup files
set undofile      " Persist undo history to disk
set noswapfile    " Do not create swap files
set nowritebackup " Do not make backup before overwriting a file

" Keep undo history between sessions
if has('persistent_undo')
	let s:undo_dir = expand('~/.vim/undo')
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
set updatetime=300 " Faster CursorHold events and plugin refreshes
set timeoutlen=500 " Wait 500ms for mapped key sequences

" Key Mappings
let mapleader = " " " Use Space as the leader key prefix

" Clear search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Split navigation
nnoremap <C-h> <C-w>h " Move to left split
nnoremap <C-j> <C-w>j " Move to split below
nnoremap <C-k> <C-w>k " Move to split above
nnoremap <C-l> <C-w>l " Move to right split

" Buffer navigation
nnoremap <leader>bn :bnext<CR>     " Go to next buffer
nnoremap <leader>bd :bdelete<CR>   " Close current buffer
nnoremap <leader>bp :bprevious<CR> " Go to previous buffer

" Save and quit shortcuts
nnoremap <leader>w :w<CR> " Save current buffer
nnoremap <leader>q :q<CR> " Quit current window
nnoremap <leader>x :x<CR> " Save (if needed) and quit

" Keep visual selection when shifting indentation
vnoremap < <gv " Outdent selection and keep it selected
vnoremap > >gv " Indent selection and keep it selected

" Enhancements
set confirm           " Prompt to save instead of failing :q on unsaved changes
set lazyredraw        " Skip redraw during macros for speed
set wildignorecase    " Case-insensitive filename completion
set shortmess-=S      " Show search match count [1/5] in the ruler
set foldmethod=indent " Fold by indentation
set foldlevelstart=99 " Open all folds on file open
set path+=**          " Recursive :find from the working directory
set wildignore+=*/node_modules/*,*/.git/*,*/dist/*,*/__pycache__/*,*.pyc,*.o

" Built-in netrw file explorer
let g:netrw_banner=0       " Hide the top banner
let g:netrw_liststyle=3    " Tree-style listing
let g:netrw_winsize=25     " Explorer pane = 25% width
let g:netrw_browse_split=0 " Open files in the same window

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
syntax on                  " Enable syntax highlighting
set background=dark        " Prefer dark background color adjustments
filetype plugin indent on  " Enable filetype detection, plugins, and indent rules

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
