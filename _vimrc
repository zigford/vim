" Platform code {{{
if has('win32')                      " Check if we are on windows.
                                     " Also supports has(unix)
    let s:os='win'                   " Set os var to win for later use
    set noendofline                  " Don't add an extra spare line at the end of each file
    set nofixeol                     " Disable the fixeol : Not really sure why this is needed
    let s:plug='$USERPROFILE/vimfiles' " Setup a variable used later to store plugins
"    set shell=powershell            " Set Shell to powershell on windows
"    set shellcmdflag=-command       " Arg for powrshell to run commands
else
    set undodir=$HOME/.vimundo
    let s:plug ='~/.vim'
    let s:uname = system('uname')    " Check which variant of Unix we are running Linux|Macos
    if s:uname =~# 'Darwin'             " If MacOS
        let s:os='mac'
    else
        if isdirectory('/mnt/c/Users/jpharris/.vim')
            let s:plug='/mnt/c/Users/jpharris/.vim'
            let s:os='wsl'
        else
            let s:os='lin'
        endif
    endif
endif

set backupdir=~/_vimtmp,~/.vimtmp,.                 " Set a single backupdir rather than leaving backup files all over the fs
set directory=~/_vimtmp,~/.vimtmp,.                 " Set dir for swp files rather than leaving swl files all over the fs
set undodir=~/vimundo,~/.vimundo,.                  " Set were persistent undo files are stored
" }}}

" Vimplug {{{

" Setup ga shortcut for easyaline in visual mode
noremap ga <Plug>(EasyAlign)
" Setup ga shortcut for easyaline in normal mode
xnoremap ga <Plug>(EasyAlign)
" xml folding
nmap gd <Plug>(ale_detail)
let g:table_mode_corner='|'
let g:ale_completion_enabled = 1
let g:ale_set_quickfix = 1
let g:ale_linter_aliases = {'ps1': 'powershell'}
if s:os=~#'win'
    let g:ale_powershell_psscriptanalyzer_executable = 'pwsh.exe'
    let g:ale_powershell_powershell_executable = 'pwsh.exe'
endif
execute 'source ' . s:plug . '/autoload/plug.vim'
if exists('*plug#begin')
    call plug#begin(s:plug . '/plugged')        " Enable the following plugins
    Plug 'tpope/vim-fugitive'
    Plug 'junegunn/gv.vim'
    Plug 'junegunn/vim-easy-align'
"    Plug 'jiangmiao/auto-pairs'
    Plug 'dhruvasagar/vim-table-mode'
"    Plug 'w0rp/ale'
    Plug 'zigford/ale'
    Plug 'tomtom/tlib_vim'
    Plug 'MarcWeber/vim-addon-mw-utils'
    Plug 'chrisbra/csv.vim'
    Plug 'PProvost/vim-ps1'
    Plug 'garbas/vim-snipmate'
    Plug 'honza/vim-snippets'
    call plug#end()
endif
set rtp+=/usr/local/opt/fzf

" }}}

" Look and feel {{{
if has('gui_running')                         " Options for gvim only
    set guioptions -=m                        " Disable menubar
    set guioptions -=T                        " Disable Status bar
    set lines=45                              " Set default amount of lines
    set columns=84                           " Set default amount of columns
    if s:os =~# 'lin'
        set guifont=Fira\ Code\ 12
    elseif s:os =~# 'mac'
        set guifont=FiraCode-Regular:h14
    else
        " Prolly windows
        "set guifont=Fira_Code_Retina:h14:cANSI:qDRAFT 
        set guifont=Lucida_Console:h11:cANSI:qDRAFT 
        set renderoptions=type:directx
        set encoding=utf-8
    endif
else
    set mouse=a
    if has('termguicolors')
        if s:os !~# 'mac'
            " tgc doesn't seem to work in terminal.app
            set termguicolors
        endif
    endif
    if s:os =~# 'lin'
        "set t_te=[H[2J
    endif
endif
colorscheme dark_mode                   " Set the default colorscheme
set background=dark
" }}}

" Default settings {{{

if has("persistent_undo")
    set undofile                              " Enable persistent undo
endif

set tabstop=4                                 " show existing tab with 4 spaces width
set shiftwidth=4                              " when indenting with '>', use 4 spaces width
set expandtab                                 " On pressing tab, insert 4 spaces
set number                                    " Show line numbers
set nowrap                                    " don't wrap text
set showmatch                                 " make code matches easier to see
set shiftround                                " indents are always right
let mapleader=","
set statusline=buf:%n\ %m%.12f\ %y\ lin:%l/%L\ col:%c%=%m
set laststatus=2
let maplocalleader=","
" }}}

" Auto Cmds {{{

augroup ALE
    autocmd!
    autocmd FileType ale-preview setlocal wrap
augroup END
augroup markdown
augroup XML
    autocmd!
    autocmd FileType xml setlocal foldmethod=indent foldlevelstart=999 foldminlines=0
augroup END
augroup HTML
    autocmd!
    autocmd FileType *html nnoremap <buffer> <localleader>f Vatzf
augroup END
augroup PS1
    autocmd!
    autocmd FileType ps1 xnoremap <leader>( <ESC>`>a)<ESC>`<i(<ESC>
    autocmd FileType ps1 nnoremap <leader>a(() vF(<ESC>`>a)<ESC>`<i(<ESC>f)
    autocmd FileType ps1 nnoremap co I#<esc>j
    autocmd FileType ps1 vnoremap co :norm i#<CR>
    autocmd FileType ps1 vnoremap cx :norm x<CR>
    autocmd FileType ps1 onoremap fn :<c-u>execute "normal! /[Ff]unction\r:nohlsearch\rV%"<cr>
    autocmd FileType ps1 onoremap FN :<c-u>execute "normal! ?[Ff]unction\r:nohlsearch\rV%"<cr>
augroup END
augroup ps1test
    autocmd!
    autocmd BufRead bad.ps1 set lines=20
augroup END
augroup markdown
    autocmd!
    autocmd FileType markdown onoremap ih :<c-u>execute "normal! ?^[=-][=-]\\+$\r:nohlsearch\rkvg_"<cr>
    autocmd FileType markdown onoremap ah :<c-u>execute "normal! ?^[=-][=-]\\+$\r:nohlsearch\rg_vk0"<cr>
augroup END
augroup vimrc
    autocmd!
    autocmd BufWritePost .vimrc,_vimrc source $MYVIMRC
augroup END
augroup vim
    autocmd FileType vim nnoremap co I"<esc>j
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType vim nnoremap <localleader>ll :exe getline(".")<CR>|          " Execute the selected line as vimscript
    autocmd FileType vim nnoremap <localleader>gg :source %<CR>|          " Execute the selected line as vimscript
augroup END
augroup aledebug
    autocmd!
    autocmd BufReadPre ps1.vim nnoremap <localleader>dd :call ale#debugging#Info()<cr>
    autocmd BufReadPre psscriptanalyzer.vim nnoremap <localleader>dd :call ale#debugging#Info()<cr>
augroup END
augroup email
    autocmd!
    autocmd BufRead mutt-* setlocal spell
                \ spelllang=en_au
                \ formatoptions+=w
                \ textwidth=80
augroup END
"}}}

" Special functions {{{
function! ToggleSyntax()
    if exists("g:syntax_on")
        syntax off
    else
        syntax enable
    endif
endfunction

"}}}

" Abreviations {{{
iabbrev ssig -- <cr>Jesse Harris<cr>jesse@zigford.org
"}}}

" Mappings {{{
nnoremap <silent> <leader>s :call ToggleSyntax()<CR>|   " M
nnoremap <silent> <leader>w :set wrap!<CR>
nnoremap <silent> <leader>n :set number!<CR>
nnoremap <leader>, ,|                         " remap leader+, to ,
nnoremap <Space> <PageDown>|
inoremap <c-u> <esc>viwUwa|                   " Map Ctrl+u to uppercase current word in insertmode
nnoremap <c-u> viwU|                          " Map Ctrl+u to uppercase current word in normalmode
nnoremap <leader>ev :vsplit $MYVIMRC<CR>|     " Edit VimRC in a v split
nnoremap <leader>eV :e $MYVIMRC<CR>|          " Edit VimRC in fullscreen
nnoremap <leader>cc :close<CR>|               " Edit VimRC in a v split
nnoremap <leader>vs :execute "rightbelow vsplit " . bufname("#")<CR>
nnoremap <leader>sp :execute "rightbelow split " . bufname("#")<CR>
" Remap tab to auto complete 
inoremap <C-@> <C-Space>
" Add double quotes to the current word
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
" map esc in insert mode to jk
inoremap jk <esc>
vnoremap jk <esc>
"inoremap <esc> <nop>
"vnoremap <esc> <nop>
" surround current word in quotes
nnoremap <leader>" viW<esc>a"<esc>hBi"<esc>lel
nnoremap <leader>' viW<esc>a'<esc>hBi'<esc>lel
" surround current visual in single quotes
xnoremap <leader>' <esc>`<i'<esc>`>la'<esc>
inoremap <leader>~~ <esc>`<i~~<esc>`>la~~<esc>
" disable arrows in normal mode
"noremap <Left> <nop>
"noremap <Right> <nop>
"noremap <Up> <nop>
"noremap <Down> <nop>
" replace above email
onoremap in@ :<c-u>execute "normal! :set iskeyword+=.\r?[a-zA-Z.]\\+@[a-zA-Z.]\\+\rvwe"<cr>
" moving around in windows:
nnoremap <c-k> <c-w>k
nnoremap <c-j> <c-w>j
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h
nnoremap <leader>,c <c-w>c
" Usefull ale mappings
nnoremap <leader>da :call ale#debugging#Info()<CR>
if s:os =~#'win'
    nnoremap <leader>ea :e 
    \   ~\vimfiles\plugged\ale\ale_linters\powershell\psscriptanalyzer.vim<CR>
else
    nnoremap <leader>ea :e 
    \   ~/.vim/plugged/ale/ale_linters/powershell/psscriptanalyzer.vim<CR>
endif
nnoremap <leader>sll :call ShowLongLines()<Cr>
"}}}

" Custom functions {{{

function! ShowLongLines() abort
    highlight OverLength ctermbg=red ctermfg=white guibg=#592929
    match OverLength /\%80v.\+/
endfunction

function! SetFileCount(files) abort
    let l:cols = a:files * 85
    let &columns = l:cols
endfunction

" }}}
