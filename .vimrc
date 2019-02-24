" Platform code {{{
if has("win32")                               " Check if we are on windows. Also supports has(unix)
    " source $VIMRUNTIME/mswin.vim            " Load a special vimscript a add ctrl+c and ctrl+v support
    " behave mswin                            " Like above
    let os='win'                              " Set os var to win for later use
    set noeol                                 " Don't add an extra spare line at the end of each file
    set nofixeol                              " Disable the fixeol : Not really sure why this is needed
    set backupdir=~/_vimtmp,.                 " Set a single backupdir rather than leaving backup files all over the fs
    set directory=~/_vimtmp,.                 " Set dir for swp files rather than leaving swl files all over the fs
    set undodir=$USERPROFILE/vimfiles/VIM_UNDO_FILES " Set were persistent undo files are stored
    let plug='$USERPROFILE/vimfiles'          " Setup a variable used later to store plugins
    set shell=powershell                      " Set Shell to powershell on windows
    set shellcmdflag=-command                 " Arg for powrshell to run commands
else
    set backupdir=~/.vimtmp,.
    set directory=~/.vimtmp,.
    set undodir=$HOME/.vim/VIM_UNDO_FILES
    let uname = system('uname')               " Check which variant of Unix we are running Linux|Macos
    if uname =~ "Darwin"                      " If MacOS
        let plug ='~/.vim'
        let os='mac'
    else
        if isdirectory('/mnt/c/Users/jpharris/.vim')
            let plug='/mnt/c/Users/jpharris/.vim'
            let os='wsl'
        else
            let plug='~/.vim'
            let os='lin'
        endif
    endif
endif
" }}}

" Vimplug {{{

" Setup ga shortcut for easyaline in visual mode
noremap ga <Plug>(EasyAlign)
" Setup ga shortcut for easyaline in normal mode
xnoremap ga <Plug>(EasyAlign)
" xml folding
let g:table_mode_corner='|'
let g:ale_completion_enabled = 1
let g:airline#extensions#ale#enabled = 1
execute "source " . plug . "/autoload/plug.vim"
if exists('*plug#begin')
    call plug#begin(plug . '/plugged')        " Enable the following plugins
"    Plug 'tpope/vim-fugitive'
"    Plug 'junegunn/gv.vim'
"    Plug 'junegunn/vim-easy-align'
"    Plug 'jiangmiao/auto-pairs'
"    Plug 'vim-airline/vim-airline'
"    Plug 'morhetz/gruvbox'
"    Plug 'ervandew/supertab'
"    Plug 'dhruvasagar/vim-table-mode'
"    Plug 'w0rp/ale'
"    Plug 'tomtom/tlib_vim'
"    Plug 'MarcWeber/vim-addon-mw-utils'
"    Plug 'chrisbra/csv.vim'
"    Plug 'PProvost/vim-ps1'
"    Plug 'garbas/vim-snipmate'
"    Plug 'honza/vim-snippets'
"    Plug 'wesQ3/vim-windowswap'
    call plug#end()
endif
" }}}

" Look and feel {{{
if has("gui_running")                         " Options for gvim only
    set guioptions -=m                        " Disable menubar
    set guioptions -=T                        " Disable Status bar
    set lines=50                              " Set default amount of lines
    set columns=100                           " Set default amount of columns
    if os =~ "lin"
        set guifont=Fira\ Code\ 12
    elseif os =~ "mac"
        set guifont=FiraCode-Regular:h16
    else
        set guifont=Fira_Code_Retina:h12:cANSI:qDRAFT 
        set renderoptions=type:directx
        set encoding=utf-8
    endif
    set background=dark
    colorscheme dark_mode                       " Set the default colorscheme
else
    set mouse=a
    if has('termguicolors')
        if os =~ "mac"
            " tgc doesn't seem to work in terminal.app
            set background=dark
            colorscheme dark_mode                   " Set the default colorscheme
        else
            set termguicolors                     " Enable termguicolors for consoles which support 256.
            set background=dark
            colorscheme default                   " Set the default colorscheme
        endif
    else
        if os =~ "mac"
            set background=dark
            colorscheme gruvbox                   " Set the default colorscheme
        endif
    endif
endif
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
let mapleader = ","
set statusline=%m{%n}%f\ %y\ %l/%L\ %c
set laststatus=2
" let maplocalleader=","
" }}}

" Auto Cmds {{{

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
    autocmd FileType ps1 onoremap fn :<c-u>execute "normal! /[Ff]unction\r:nohlsearch\rV%"<cr>
    autocmd FileType ps1 onoremap FN :<c-u>execute "normal! ?[Ff]unction\r:nohlsearch\rV%"<cr>
augroup END
augroup markdown
    autocmd!
    autocmd FileType markdown onoremap ih :<c-u>execute "normal! ?^[=-][=-]\\+$\r:nohlsearch\rkvg_"<cr>
    autocmd FileType markdown onoremap ah :<c-u>execute "normal! ?^[=-][=-]\\+$\r:nohlsearch\rg_vk0"<cr>
augroup END
augroup vimrc
    autocmd!
    autocmd BufReadPre .vimrc setlocal foldmethod=marker
    autocmd BufWritePost .vimrc source ~/.vimrc
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
nnoremap <F2> :exe getline(".")<CR>|          " Execute the selected line as vimscript
nnoremap <leader>ev :vsplit $MYVIMRC<CR>|     " Edit VimRC in a v split
nnoremap <leader>lv :source $MYVIMRC<CR>|     " Reload VimRC
" Remap tab to auto complete 
inoremap <C-@> <C-Space>
" Add double quotes to the current word
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
" map esc in insert mode to jk
inoremap jk <esc>
vnoremap jk <esc>
inoremap <esc> <nop>
vnoremap <esc> <nop>
" surround current word in quotes
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
" surround current visual in single quotes
nnoremap <leader>' <esc>`<i'<esc>`>la'<esc>
" disable arrows in normal mode
noremap <Left> <nop>
noremap <Right> <nop>
noremap <Up> <nop>
noremap <Down> <nop>
onoremap in@ :<c-u>execute "normal! :set iskeyword+=.\r?[a-zA-Z.]\\+@[a-zA-Z.]\\+\rvwe"<cr>
"}}}
