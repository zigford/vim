if has("win32")                               " Check if we are on windows. Also supports has(unix)
    source $VIMRUNTIME/mswin.vim              " Load a special vimscript a add ctrl+c and ctrl+v support
    behave mswin                              " Like above
    set ff=dos                                " Set default file format to dos
    let os='win'                              " Set os var to win for later use
    set noeol                                 " Don't add an extra spare line at the end of each file
    set nofixeol                              " Disable the fixeol : Not really sure why this is needed
    set backupdir=~/_vimtmp,.                 " Set a single backupdir rather than leaving backup files all over the fs
    set directory=~/_vimtmp,.                 " Set dir for swp files rather than leaving swl files all over the fs
    set undodir=$USERPROFILE/vimfiles/VIM_UNDO_FILES " Set were persistent undo files are stored
    let plug='$USERPROFILE/vimfiles'                         " Setup a variable used later to store plugins
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

                                              " Attempt to start vim-plug
execute "source " . plug . "/autoload/plug.vim"
if exists('*plug#begin')
    call plug#begin(plug . '/plugged')        " Enable the following plugins
    Plug 'tpope/vim-fugitive'
    Plug 'junegunn/gv.vim'
    Plug 'junegunn/vim-easy-align'
"    Plug 'jiangmiao/auto-pairs'
"    Plug 'vim-airline/vim-airline'
    Plug 'morhetz/gruvbox'
"    Plug 'ervandew/supertab'
    Plug 'tomtom/tlib_vim'
    Plug 'MarcWeber/vim-addon-mw-utils'
    Plug 'chrisbra/csv.vim'
    Plug 'PProvost/vim-ps1'
    Plug 'garbas/vim-snipmate'
    Plug 'honza/vim-snippets'
    Plug 'wesQ3/vim-windowswap'
    call plug#end()
endif

if has("gui_running")                         " Options for gvim only
    set guioptions -=m                        " Disable menubar
    set guioptions -=T                        " Disable Status bar
"    set lines=50                              " Set default amount of lines
"    set columns=100                           " Set default amount of columns
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
    colorscheme desert                       " Set the default colorscheme
else
    set mouse=a
    if has('termguicolors')
        if os =~ "mac"
            " tgc doesn't seem to work in terminal.app
        else
            set termguicolors                     " Enable termguicolors for consoles which support 256.
        endif
        set background=dark
        colorscheme gruvbox                   " Set the default colorscheme
    endif
endif

if has("persistent_undo")
    set undofile                              " Enable persistent undo
endif

" syntax on                                   " Enable syntax highlighting
" filetype plugin indent on                   " Enable plugin based auto indent
set tabstop=4                                 " show existing tab with 4 spaces width
set shiftwidth=4                              " when indenting with '>', use 4 spaces width
set expandtab                                 " On pressing tab, insert 4 spaces
set number                                    " Show line numbers

nnoremap <F2> :exe getline(".")<CR>           " Execute the selected line as vimscript
" Remap tab to auto complete 
imap <C-@> <C-Space>
" Setup ga shortcut for easyaline in visual mode
nmap ga <Plug>(EasyAlign)
" Setup ga shortcut for easyaline in normal mode
xmap ga <Plug>(EasyAlign)
" xml folding
augroup XML
    autocmd!
    autocmd FileType xml setlocal foldmethod=indent foldlevelstart=999 foldminlines=0
augroup END
