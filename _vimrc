" Platform code {{{
let s:home = $HOME                   " Setting a custom variable for home
                                     " so that on WSL we can user the Windows
                                     " home.
if has('win32')                      " Check if we are on windows.
                                     " Also supports has(unix)
    let s:os='win'                   " Set os var to win for later use
    set noendofline                  " Don't add an extra spare line at the
                                     " end of each file
    set nofixeol                     " Disable the fixeol : Not really sure
                                     " why this is needed
else
    if &term == 'xterm-kitty'
        set t_ut=
    endif
    let s:uname = system('uname')    " Check which variant of Unix we are running Linux|Macos
    let s:os=(s:uname=~#'Darwin') ? 'macos' : 'lin'
    let s:WU ='jpharris'
    let s:WSL='/mnt/c/Users/'.s:WU
    if isdirectory(s:WSL) 
        let s:home = '/mnt/c/Users/'.s:WU
    endif
endif

let s:vo = s:home . "/.vimother/"
if !isdirectory(s:vo . "tmp")
    call mkdir(s:vo . "tmp", "p")
    call mkdir(s:vo . "undo", "p")
    call mkdir(s:vo . "views", "p")
    call mkdir(s:vo . "plug", "p")
endif
let &backupdir = s:vo . "tmp"        " Set a single backupdir rather than leaving backup files all over the fs
let &directory = s:vo . "tmp"        " Set dir for swp files rather than leaving swl files all over the fs
let &undodir = s:vo . "undo"         " Set were persistent undo files are stored
let &viewdir = s:vo . "views"
let &viminfofile = s:vo . "viminfo"
let s:plug = s:vo . 'plug'
" }}}

" Vimplug {{{

" Setup ga shortcut for easyaline in visual mode
noremap ga <Plug>(EasyAlign)
" Setup ga shortcut for easyaline in normal mode
xnoremap ga <Plug>(EasyAlign)
nmap gd <Plug>(ale_detail)
let g:table_mode_corner='|'
let g:ale_completion_enabled = 1
let g:ale_set_quickfix = 1
let g:ale_linter_aliases = {'ps1': 'powershell'}
"let g:ale_linters = {'powershell': ['psscriptanalyzer']}
let g:ale_linters = {'powershell': ['powershell']}
if s:os=~#'win'
    let g:ale_powershell_psscriptanalyzer_executable = 'powershell.exe'
    let g:ale_powershell_powershell_executable = 'powershell.exe'
else
    let g:ale_powershell_powershell_executable = 'pwsh-preview'
    let g:vimwiki_list = [{'path': '~/Documents/vimwiki'},
                \{'path': '~/Documents/personal_vimwiki'}]
    let g:vimwiki_text_ignore_newline = 0
    "\ 'syntax': 'markdown', 'ext': '.md'}]
endif
execute 'source ' . split(&rtp, ',')[0] . '/autoload/plug.vim'
if exists('*plug#begin')
    call plug#begin(s:plug)        " Enable the following plugins
    Plug 'tpope/vim-fugitive'
    Plug 'junegunn/gv.vim'
    Plug 'junegunn/vim-easy-align'
    Plug 'dhruvasagar/vim-table-mode'
    Plug 'dense-analysis/ale'
    Plug 'tomtom/tlib_vim'
    Plug 'gruvbox-community/gruvbox'
"    Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}
    Plug 'MarcWeber/vim-addon-mw-utils'
    Plug 'chrisbra/csv.vim'
    Plug 'zigford/vim-powershell'
    Plug 'garbas/vim-snipmate'
    Plug 'honza/vim-snippets'
    Plug 'vimwiki/vimwiki'
    Plug 'thinca/vim-fontzoom'
    Plug 'rodjek/vim-puppet'
    Plug '/usr/share/vim'
    call plug#end()
endif
"set rtp+=/usr/local/opt/fzf

" }}}

" Look and feel {{{
if has('gui_running')                         " Options for gvim only
    set guioptions -=m                        " Disable menubar
    set guioptions -=T                        " Disable Status bar
    if ! exists("g:linesset")
        let g:linesset = "yes"
        set lines=50                              " Set default amount of lines
        set columns=90                            " Set default amount of columns
    endif
    if s:os =~# 'lin'
        set guifont=Cascadia\ Code\ 13
    elseif s:os =~# 'mac'
        set guifont=FiraCode-Regular:h14
    else
        " Prolly windows
        set guifont=Fira_Code:h11:cANSI:qDRAFT 
        "set guifont=Lucida_Console:h11:cANSI:qDRAFT 
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
        if exists ("$TMUX_PANE")
            set notgc
        endif
    endif
endif

" The following is a bit of vimscript to set the colorscheme based on
" time of day

if filereadable("/home/harrisj/.config/vim/mode")
    let s:mode=system('cat /home/harrisj/.config/vim/mode')
    if s:mode =~ 'light' 
        set background=light
    else
        set background=dark
    endif
else
    let s:time = has('win32') ? system('time /t') : system('date "+%I:%M %p"')
    " logic to handle day/night
    let s:hour = split(s:time, ':')[0]
    let s:PM   = split(s:time)[1]

    if (s:PM ==? 'PM' && 
    \ (s:hour > 7 && s:hour != 12)) ||
    \ (s:PM ==? 'AM' &&
    \ (s:hour < 8 || s:hour == 12))              " Between 8pm and 8am is night
        set background=dark
    else
        set background=light
    endif
endif
colorscheme gruvbox
"colorscheme dark_mode
" }}}

" Default settings {{{

if has("persistent_undo")
    set undofile                              " Enable persistent undo
endif

set tabstop=4                                 " show existing tab with 4 spaces width
set shiftwidth=4                              " when indenting with '>', use 4 spaces width
set expandtab                                 " On pressing tab, insert 4 spaces
set number                                    " Show line numbers
set rnu
set nowrap                                    " don't wrap text
set showmatch                                 " make code matches easier to see
set shiftround                                " indents are always right
let mapleader=","
set statusline=buf:%n\ %m%.25f\ %y\ lin:%l/%L\ col:%c%=%m
set laststatus=2
let maplocalleader=","
set path+=**                                  " 
set wildmenu
set wildignore+=**/node_modules/**

" }}}

" Auto Cmds {{{
augroup All
    autocmd!
"    autocmd VimEnter * colorscheme gruvbox
"    autocmd VimEnter call * libcallnr("gvimborder.dll", "SetBorder", 0x080808)
    autocmd BufWinLeave * silent! mkview
    autocmd BufWinEnter * silent! loadview
augroup END
augroup ALE
    autocmd!
    autocmd FileType ale-preview setlocal wrap
augroup END
augroup SetupLOG
    autocmd!
    autocmd BufRead setupact.log set filetype=winlog
    autocmd BufRead dism*.log set filetype=winlog
    autocmd FileType winlog call SetFileCount(3)
    autocmd FileType winlog highlight WinError ctermbg=red ctermfg=white guibg=#292929 guifg=red
    autocmd FileType winlog highlight WinWarning ctermbg=blue ctermfg=white guibg=#292929 guifg=white
    autocmd FileType winlog syntax match WinError /\v.*Error.*/
    autocmd FileType winlog syntax match WinWarning /\v.*Warning.*/
augroup END
augroup XML
    autocmd!
    autocmd FileType xml setlocal foldmethod=indent foldlevelstart=99 foldminlines=0
    autocmd FileType xml nnoremap <leader>fm :%s/></>\r</g<CR>G=gg
    autocmd BufRead CompatData*.xml silent! exec "%s/></>\r</g|norm!G=ggzR"
augroup END
augroup HTML
    autocmd!
    autocmd FileType *html nnoremap <buffer> <localleader>f Vatzf
augroup END
augroup PS1
    autocmd!
    autocmd FileType powershell xnoremap <leader>( <ESC>`>a)<ESC>`<i(<ESC>
    autocmd FileType powershell nnoremap <leader>a(() vF(<ESC>`>a)<ESC>`<i(<ESC>f)
    autocmd FileType powershell nnoremap co I#<esc>j
    autocmd FileType powershell vnoremap co :norm i#<CR>
    autocmd FileType powershell vnoremap cx :norm x<CR>
    autocmd FileType powershell onoremap fn :<c-u>execute "normal! /[Ff]unction\r:nohlsearch\rV%"<cr>
    autocmd FileType powershell onoremap FN :<c-u>execute "normal! ?[Ff]unction\r:nohlsearch\rV%"<cr>
    autocmd FileType powershell nmap <leader>cf :norm "+yFN<CR>
    autocmd FileType powershell xnoremap <F8> y<C-W>w<C-W>"0<C-W>w
    autocmd FileType powershell nnoremap <leader>fn y<C-W>w<C-W>"0<C-W>w
    "autocmd FileType powershell nnoremap <F5> call term_sendkeys(9, '& "%"<CR>')
    autocmd FileType powershell iabbrev <buffer> gci Get-ChildItem
    autocmd FileType powershell iabbrev <buffer> % ForEach-Object
    autocmd FileType powershell iabbrev <buffer> ? Where-Object
    autocmd FileType powershell iabbrev <buffer> gc Get-Content
    "autocmd FileType powershell iabbrev for for ($i=0; $i -lt 10; $i++) {<cr>
"    if has('win32')
"        autocmd FileType powershell set makeprg=pwsh\ -command\ \"&{trap{$_.tostring();continue}&{$c=gc\ '%';$c=[string]::join([environment]::newline,$c);[void]$executioncontext.invokecommand.newscriptblock($c)}}\"
"    else
"        autocmd FileType powershell set makeprg=pwsh\ -command\ \"&{
"            \trap{\\$_.tostring\();continue}&{
"            \\\$c=gc\ '%';
"            \\\$c=[string]::join([environment]::newline,\\$c);
"            \[void]\\$executioncontext.invokecommand.newscriptblock(\\$c)}
"        \}\"
"    endif
"    autocmd FileType powershell set errorformat=%EAt\ line:%l\ char:%c,%-C+%.%#,%Z%m,%-G\\s%#
augroup END
augroup ps1test
    autocmd!
    autocmd BufRead bad.ps1 set lines=20
augroup END
augroup markdown
    autocmd!
    autocmd FileType markdown setlocal textwidth=80 spell spelllang=en_au
    autocmd FileType markdown onoremap ih :<c-u>execute "normal! ?^[=-][=-]\\+$\r:nohlsearch\rkvg_"<cr>
    autocmd FileType markdown onoremap ah :<c-u>execute "normal! ?^[=-][=-]\\+$\r:nohlsearch\rg_vk0"<cr>
    autocmd FileType markdown nnoremap <leader>iv :call InsertVideoTag()<cr>
    autocmd FileType markdown iabbrev sig If you have and corrections or memories I can add to this post
            \, please email<cr>me at jesse@zigford.org
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
augroup JSON
    autocmd!
    autocmd BufRead *.json set ft=json
    autocmd FileType json :execute ":%! python -m json.tool\r"
    autocmd FileType json setlocal foldmethod=syntax shiftwidth=2 tabstop=2
    autocmd FileType json nnoremap <localleader>f :%! python -m json.tool<CR>
augroup END
augroup email
    autocmd!
    autocmd BufRead mutt-* setlocal spell
                \ spelllang=en_au
                \ formatoptions+=w
                \ textwidth=80
augroup END
augroup menu
    autocmd!
    autocmd BufRead /home/harrisj/src/usceduau/SaSTeam-General/Menu/* set columns=200
augroup END
"}}}

" Abreviations {{{
iabbrev ssig -- <cr>Jesse Harris<cr>jesse@zigford.org
iabbrev powerShell  PowerShell
iabbrev Powershell  PowerShell
iabbrev powershell  PowerShell
"}}}

" Mappings {{{
nnoremap <silent> <leader>s :call ToggleSyntax()<CR>|   " M
nnoremap <silent> <leader>w :set wrap!<CR>
nnoremap <silent> <leader>n :set number!<CR>
nnoremap <leader>, ,|                         " remap leader+, to ,
nnoremap <Space> <Nop>|
inoremap <c-u> <esc>viwUwa|                   " Map Ctrl+u to uppercase current word in insertmode
nnoremap <c-u> viwU|                          " Map Ctrl+u to uppercase current word in normalmode
nnoremap <leader>ev :vsplit $MYVIMRC<CR>|     " Edit VimRC in a v split
nnoremap <leader>eV :e $MYVIMRC<CR>|          " Edit VimRC in fullscreen
nnoremap <leader>cc :close<CR>:call SetFileCount(1)<CR>|               " Edit VimRC in a v split
nnoremap <leader>vs :execute "rightbelow vsplit " . bufname("#")<CR>
nnoremap <leader>sp :execute "rightbelow split " . bufname("#")<CR>
" Remap tab to auto complete 
inoremap <C-@> <C-Space>
" Add double quotes to the current word
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
" map esc in insert mode to jk
inoremap jk <esc>
vnoremap jk <nop>
"inoremap <esc> <nop>
"vnoremap <esc> <nop>
" surround current word in quotes
nnoremap <leader>" viW<esc>a"<esc>hBi"<esc>lel
nnoremap <leader>' viW<esc>a'<esc>hBi'<esc>lel
" surround current visual in single quotes
xnoremap <leader>' <esc>`<i'<esc>`>la'<esc>
inoremap <leader>~~ <esc>`<i~~<esc>`>la~~<esc>
" enter mapped to nohlsearch
nnoremap <silent> <cr> :nohlsearch<cr>
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
nnoremap <leader>f :FZF<CR>
" Usefull ale mappings
nnoremap <leader>da :call ale#debugging#Info()<CR>
if s:os =~#'win'
    nnoremap <leader>ea :e 
    \   ~\vimfiles\plugged\ale\ale_linters\powershell\powershell.vim<CR>
else
    nnoremap <leader>ea :e 
    \   ~/.vim/plugged/ale/ale_linters/powershell/powershell.vim<CR>
endif
nnoremap <leader>sll :call ShowLongLines()<Cr>
nnoremap <leader>p :call TogglePatchLine()<Cr>
nnoremap <leader>> :cn<CR>
nnoremap <leader>< :cp<CR>
nnoremap <leader>vs :vs<CR>:call SetFileCount(2)<CR>
"}}}

" Custom functions {{{

function! ShowLongLines() abort
    highlight OverLength ctermbg=red ctermfg=white guibg=#592929
    match OverLength /\%80v.\+/
endfunction

function! SetFileCount(files) abort
    let l:cols = a:files * 85
    let &columns = l:cols
    execute "normal! \<C-w>="
endfunction

function! ToggleSyntax()
    if exists("g:syntax_on")
        syntax off
    else
        syntax enable
    endif
endfunction

function! TogglePatchLine() abort
    let a:curline = getline(line('.'))
    let a:char = " "
    if len(a:curline)
        let a:char = a:curline[0]
    endif
    let a:cur_pos = getpos('.')
    if a:char == "-"
        normal 0r 
        call setpos('.', a:cur_pos)
        normal j
    elseif a:char == "+"
        normal dd
    endif
endfunction

function! YesNo() abort
    let l:curline = getline(line('.'))
    let l:cur_pos = getpos('.')
    if len(l:curline)
        normal! $b
        let l:char = strcharpart(getline('.')[col('.') - 1:], 0, 1)
        if l:char == ","
            normal! ehhh
            execute "normal! cwyes\<esc>"
        elseif l:char == "y"
            execute "normal! xxxi no\<esc>"
        elseif l:char == "n"
            execute "normal! dwi  \<esc>"
        endif
    endif
    call setpos('.', l:cur_pos)
endfunction
nnoremap <leader>. :call YesNo()<CR>

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

function! InsertVideoTag() abort
    let l:cl=line('.')
    let l:pastesetting = &paste
    call append(l:cl,'<div id="video">')
    call append(l:cl+1,'    <video width="100%" controls>')
    call append(l:cl+2,'        <source ')
    call append(l:cl+3,'          src=""')
    call append(l:cl+4,'          type="video/mp4">')
    call append(l:cl+5,'          Your browser does not support the video tag.')
    call append(l:cl+6,'    </video>')
    call append(l:cl+7,'</div>')
    call append(l:cl+8,'')
    call append(l:cl+9,'You can download the file by right clicking [here][1] a
                \nd click "save-as"')
    call append(l:cl+10,'')
    call setpos('.',[0,l:cl+4,40,0])
    startinsert
endfunction

" }}}
