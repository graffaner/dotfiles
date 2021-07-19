" -----------------------------------------------------------------------------
" This config is targeted for Vim 8.1+ and expects you to have Plug installed.
" -----------------------------------------------------------------------------

" -----------------------------------------------------------------------------
" Plugins and their settings
" -----------------------------------------------------------------------------

" Specify a directory for plugins.
call plug#begin('~/.vim/plugged')

" color theme plugins
" Atom One Dark / Light theme.
Plug 'rakr/vim-one'

" SOLARIZED COLORSCHEME FOR VIM
Plug 'altercation/vim-colors-solarized'

" vim-moonfly-colors
Plug 'bluz71/vim-moonfly-colors'

" vim Solarized 8: True Colors
" a variant from the original Solarized
Plug 'lifepillar/vim-solarized8'

" PaperColor Theme
Plug 'NLKNguyen/papercolor-theme'

" ayu vim theme color
Plug 'ayu-theme/ayu-vim'

" Gruvbox vim color theme
Plug 'morhetz/gruvbox'

" Better manage Vim sessions.
" Plug 'tpope/vim-obsession'

" Zoom in and out of a specific split pane (similar to tmux).
" Plug 'dhruvasagar/vim-zoom'

" Pass focus events from tmux to Vim (useful for autoread and linting tools).
" Plug 'tmux-plugins/vim-tmux-focus-events'

" Navigate and manipulate files in a tree view.
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-mapping-mark-children.vim'

" Navigate and manipulate files in a tree view.
Plug 'scrooloose/nerdtree'

" Helpers for moving and manipulating files / directories.
Plug 'tpope/vim-eunuch'

" Run a diff on 2 directories.
" Plug 'will133/vim-dirdiff'

" Run a diff on 2 blocks of text.
" Plug 'AndrewRadev/linediff.vim'

" Add spelling errors to the quickfix list (vim-ingo-library is a dependency).
" Plug 'inkarkat/vim-ingo-library' | Plug 'inkarkat/vim-SpellCheck'

" Briefly highlight which text was yanked.
" Plug 'machakann/vim-highlightedyank'

" Highlight which character to jump to when using horizontal movement keys.
" Plug 'unblevable/quick-scope'

" Modify * to also work with visual selections.
" Plug 'nelstrom/vim-visual-star-search'

" Automatically clear search highlights after you move your cursor.
" Plug 'haya14busa/is.vim'

" Handle multi-file find and replace.
" Plug 'mhinz/vim-grepper'

" Better display unwanted whitespace.
" Plug 'ntpeters/vim-better-whitespace'

" Toggle comments in various ways.
" Plug 'tpope/vim-commentary'
Plug 'scrooloose/nerdcommenter'
let NERDSpaceDelims=1

" Automatically set 'shiftwidth' + 'expandtab' (indention) based on file type.
" Plug 'tpope/vim-sleuth'

" A number of useful motions for the quickfix list, pasting and more.
" Plug 'tpope/vim-unimpaired'

" Drastically improve insert mode performance in files with folds.
" Plug 'Konfekt/FastFold'

" Show git file changes in the gutter.
" Plug 'mhinz/vim-signify'

" A git wrapper.
Plug 'tpope/vim-fugitive'

" Dim paragraphs above and below the active paragraph.
" Plug 'junegunn/limelight.vim'

" Distraction free writing by removing UI elements and centering everything.
" Plug 'junegunn/goyo.vim'

" A bunch of useful language related snippets (ultisnips is the engine).
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" Automatically show Vim's complete menu while typing.
" Plug 'vim-scripts/AutoComplPop'

" Run test suites for various languages.
" Plug 'janko/vim-test'

" Tagbar
Plug 'majutsushi/tagbar'
" map a key to turn on and off Tagbar
nmap <F8> :TagbarToggle<CR>
" point the plugin to the ctag executable
" if ctag not in search path
" let g:tagbar_ctags_bin = 'C:\ctags_x86\ctags.exe'

" Bookmarks
Plug 'mattesgroeger/vim-bookmarks'
" highlight BookmarkSign ctermbg=NONE ctermfg=160
" highlight BookmarkLine ctermbg=194 ctermfg=NONE
let g:bookmark_sign = '!'
"let g:bookmark_sign = '>>'
let g:bookmark_highlight_lines = 1
let g:bookmark_annotation_sign = '##'

" Vim starting page customization
Plug 'mhinz/vim-startify'

" CtrlP: a buffer search utility
Plug 'ctrlpvim/ctrlp.vim'
" When invoked, unless a starting directory is specified,
" CtrlP will set its local working directory according to this variable
let g:ctrlp_working_path_mode = 'ra'

" Vim airline
Plug 'vim-airline/vim-airline'
let g:airline#extensions#tabline#enabled=1  " show buffer info in vim-airline
let g:airline#extensions#tabline#buffer_nr_show=1   " show buffer number
set laststatus=2            	" show statusline when vim starts in vim-airline

" Vim-airline-theme
Plug 'vim-airline/vim-airline-themes'
"let g:airline_theme='simple'
let g:airline_theme='molokai'
"let g:airline_powerline_fonts = 1

" Plugin for Ack and Ag code base search tool
Plug 'mileszs/ack.vim'
" to use the silversearcher Ag tool
let g:ackprg = 'ag --vimgrep'

" fzf (fuzzy finder) vim plugin
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
"nnoremap <silent> <C-f> :Files<CR>

" vim surround
" Surround.vim is all about surroundings: parentheses, brackets, quotes, XML
" tags, and more. The plugin provides mappings to easily delete, change and
" add such surroundings in pairs.
Plug 'tpope/vim-surround'

" Languages and file types.
" Plug 'cakebaker/scss-syntax.vim'
" Plug 'chr4/nginx.vim'
Plug 'chrisbra/csv.vim'
Plug 'ekalinin/dockerfile.vim'
" Plug 'elixir-editors/vim-elixir'
" Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'godlygeek/tabular' | Plug 'tpope/vim-markdown'

" Markdown Preview for Vim
" Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }
Plug 'iamcco/markdown-preview.nvim', {'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
let g:mkdp_open_to_the_world = 1
let g:mkdp_open_ip = '127.0.0.1'
let g:mkdp_echo_preview_url = 1
let g:mkdp_port = ''

" Plug 'jvirtanen/vim-hcl'
" Plug 'lifepillar/pgsql.vim'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'stephpy/vim-yaml'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-git'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-rails'
Plug 'vim-python/python-syntax'
Plug 'vim-ruby/vim-ruby'
Plug 'wgwoods/vim-systemd-syntax'

" C3.Ai syntax plugins
Plug '~/c3ai_syntax'

call plug#end()

" -----------------------------------------------------------------------------
" Color settings
" -----------------------------------------------------------------------------

" Enable 24-bit true colors if your terminal supports it.
if (has("termguicolors"))
  " https://github.com/vim/vim/issues/993#issuecomment-255651605
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

  set termguicolors
endif

" Enable syntax highlighting.
syntax on

" Set the color scheme.
" colorscheme one
" colorscheme solarized8
" colorscheme PaperColor

" let ayucolor="dark"   " for dark version of theme
" colorscheme ayu
colorscheme gruvbox

" set background=dark

" -----------------------------------------------------------------------------
" Cursor settings for Vim in WSL terminal
" -----------------------------------------------------------------------------
let &t_SI.="\e[5 q"     "SI = INSERT mode
let &t_SR.="\e[4 q"     "SR = REPLACE mode
let &t_EI.="\e[1 q"     "EI = NORMAL mode (ELSE)

" -----------------------------------------------------------------------------
" Basic Settings
"   Research any of these by running :help <setting>
" -----------------------------------------------------------------------------
set nocompatible
set colorcolumn=80
set showmode
set wrap            " wrap text if longer than window width
set tabstop=4   	" number of visual spaces per TAB
set softtabstop=4	" number of spaces in tab when editing
set shiftwidth=4	" the size of indent
set textwidth=0    	" set the text width
set expandtab   	" tab key inserts space instead of tab
" set autoindent      	" auto indentation, not always work
set fileformat=unix
set smarttab   		" insert spaces or tabs to go to the next indent
set number          	" show line numbers
set showcmd         	" show command in bottom bar
set cursorline      	" highlight current line
set wildmenu        	" visual autocomplete for command menu
set showmatch       	" highlight matching [{()}]
" set guifont=Cascadia\ Mono:h10   " default font
set fenc=utf-8              	" set font encoding
set backspace=indent,eol,start	" backspace key works as typically
set incsearch   			" show match as search proceeds
set hlsearch   				" search highlighting
set ruler                   	" show current line and column
set encoding=utf-8
set foldmethod=indent       " Enable folding, creates folds based upon line indents.
set foldlevel=99

" -----------------------------------------------------------------------------
" Plugin settings, mappings and autocommands
" -----------------------------------------------------------------------------
" lambdalisue/fern.vim
" disable some settings and mappings
let g:fern#disable_default_mappings   = 1
let g:fern#disable_drawer_auto_quit   = 1
let g:fern#disable_viewer_hide_cursor = 1
" Candidate fern launch mappings
noremap <silent> <Leader>d :Fern . -drawer -width=35 -toggle<CR><C-w>=
noremap <silent> <Leader>f :Fern . -drawer -reveal=% -width=35<CR><C-w>=
noremap <silent> <Leader>. :Fern %:h -drawer -width=35<CR><C-w>=
" Candidate fern operation mappings
function! FernInit() abort
    nmap <buffer><expr>
        \ <Plug>(fern-my-open-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open:select)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )
    nmap <buffer> <CR> <Plug>(fern-my-open-expand-collapse)
    nmap <buffer> <2-LeftMouse> <Plug>(fern-my-open-expand-collapse)
    nmap <buffer> m <Plug>(fern-action-mark:toggle)
    nmap <buffer> N <Plug>(fern-action-new-file)
    nmap <buffer> K <Plug>(fern-action-new-dir)
    nmap <buffer> D <Plug>(fern-action-remove)
    nmap <buffer> V <Plug>(fern-action-move)
    nmap <buffer> R <Plug>(fern-action-rename)
    nmap <buffer> s <Plug>(fern-action-open:split)
    nmap <buffer> v <Plug>(fern-action-open:vsplit)
    nmap <buffer> r <Plug>(fern-action-reload)
    nmap <buffer> <nowait> d <Plug>(fern-action-hidden:toggle)
    nmap <buffer> <nowait> < <Plug>(fern-action-leave)
    nmap <buffer> <nowait> > <Plug>(fern-action-enter)
endfunction

augroup FernEvents
    autocmd!
    autocmd FileType fern call FernInit()
augroup END

" fzf (fuzzy finder) vim plugin
" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
" let $FZF_DEFAULT_OPTS="--ansi"
