if has("win32")                               " Check if we are on windows. Also supports has(unix)
    source $VIMRUNTIME/mswin.vim              " Load a special vimscript a add ctrl+c and ctrl+v support
    behave mswin                              " Like above
    set ff=dos                                " Set default file format to dos
    set noeol                                 " Don't add an extra spare line at the end of each file
    set nofixeol                              " Disable the fixeol : Not really sure why this is needed
    set backupdir=~/_vimtmp,.                 " Set a single backupdir rather than leaving backup files all over the fs
    set directory=~/_vimtmp,.                 " Set dir for swp files rather than leaving swl files all over the fs
    set undodir=$HOME/vimfiles/VIM_UNDO_FILES " Set were persistent undo files are stored
    let home='~/.vim'                         " Setup a variable used later to store plugins
    set shell=powershell                      " Set Shell to powershell on windows
    set shellcmdflag=-command                 " Arg for powrshell to run commands
else
    set backupdir=~/.vimtmp,.
    set directory=~/.vimtmp,.
    set undodir=$HOME/.vim/VIM_UNDO_FILES
    let uname = system('uname')               " Check which variant of Unix we are running Linux|Macos
    if uname =~ "Darwin"                      " If MacOS
        let home='~/.vim'
    else
        if exists('/mnt/c/Users/jpharris')
            let home='/mnt/c/Users/jpharris/.vim'
        else
            let home='~/.vim'
        endif
    endif
endif
                                              " Remove menu bars
if has("gui_running")                         " Options for gvim only
    set guioptions -=m                        " Disable menubar
    set guioptions -=T                        " Disable Status bar
    set lines=50                              " Set default amount of lines
    set columns=100                           " Set default amount of columns
else
    if has('termguicolors')
        set termguicolors                     " Enable termguicolors for consoles which support 256.
    endif
endif

if has("persistent_undo")
    set undofile                              " Enable persistent undo
endif

colorscheme evening                           " Set the default colorscheme
                                              " Attempt to start vim-plug
execute "source " . home . "/autoload/plug.vim"
if exists('*plug#begin')
    call plug#begin(home . '/plugged')        " Enable the following plugins
    Plug 'tpope/vim-fugitive'
    Plug 'junegunn/gv.vim'
    Plug 'junegunn/vim-easy-align'
    Plug 'jiangmiao/auto-pairs'
    Plug 'vim-airline/vim-airline'
    Plug 'ervandew/supertab'
    Plug 'tomtom/tlib_vim'
    Plug 'MarcWeber/vim-addon-mw-utils'
    Plug 'PProvost/vim-ps1'
    Plug 'garbas/vim-snipmate'
    Plug 'honza/vim-snippets'
    call plug#end()
endif

syntax on                                     " Enable syntax highlighting
filetype plugin indent on                     " Enable plugin based auto indent
set tabstop=4                                 " show existing tab with 4 spaces width
set shiftwidth=4                              " when indenting with '>', use 4 spaces width
set expandtab                                 " On pressing tab, insert 4 spaces
set number                                    " Show line numbers

" Map F5 to python.exe %=current file
nnoremap <silent> <F5> :!clear;python %<CR>
" Remap tab to auto complete 
imap <C-@> <C-Space>
" Setup ga shortcut for easyaline in visual mode
nmap ga <Plug>(EasyAlign)
" Setup ga shortcut for easyaline in normal mode
xmap ga <Plug>(EasyAlign)