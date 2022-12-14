" -------------------- CASPER'S VIMRC -----------------------------------------

" -------------------- PLUGINS ------------------------------------------------
" ALE & prettier
let g:ale_fix_on_save = 1
let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['prettier']

" easymotion
"     disable default mapping
let g:EasyMotion_do_mapping = 0

"     jump anywhere with minimal keystrokes
nmap s <Plug>(easymotion-overwin-f)

"     case insensitive
let g:EasyMotion_smartcase = 1

"     move to any word
map <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

"     move to any line
map <Leader>l <Plug>(easymotion-bd-jk)
nmap <Leader>l <Plug>(easymotion-overwin-line)

"     move to line above or below
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" -------------------- GVIM / WINDOWS -----------------------------------------
" disable warning bell sound
set belloff=all

if has("gui_running")
  if has("gui_win32")
    " set font
    set guifont=InputMonoNarrow_Light:h11:cANSI

    " fullscreen DLL
    autocmd VimEnter * call libcallnr(expand("$HOME") . "\\vimfiles\\external-plugins\\gvimfullscreen\\gvimfullscreen", "ToggleFullScreen", 0)

    " activate/deactivate full screen with function key <F11>
    map <F11> <Esc>:call libcallnr(expand("$HOME") . "\\vimfiles\\external-plugins\\gvimfullscreen\\gvimfullscreen", "ToggleFullScreen", 0)<CR>

    " disable annoying menu bars
    set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
    set guioptions-=L  "remove left-hand scroll bar
  endif
endif


" -------------------- CONEMU/CMDER -------------------------------------------
" ConEmu (cmder on windows) settings, needed to make colors work.
if !empty($ConEmuBuild)
    " make 256 colors work
    set term=xterm
    set t_Co=256

    " fix character issue
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"

    " fix backspace issues with vim in ConEmu
    inoremap <Char-0x07F> <BS>
    nnoremap <Char-0x07F> <BS>
endif


" -------------------- UNICODE ------------------------------------------------
" fix unicode issues
if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    set encoding=utf-8
    setglobal fileencoding=utf-8
    "setglobal bomb
    set fileencodings=ucs-bom,utf-8,latin1
endif

" unicode test:
"   Euro symbol: [???]


" -------------------- FILE FORMAT --------------------------------------------
set ff=unix


" -------------------- COLOR/HIGHLIGHTING -------------------------------------
" syntax highlighting on
filetype plugin on
syntax on

" choose color scheme
" NOTE: This needs to happen after set t_Co
colorscheme blackboard


" -------------------- BACKSPACE ----------------------------------------------
" fix backspace setting
set backspace=indent,eol,start


" -------------------- MISC INFO ----------------------------------------------
" show column and line info
set ruler


" -------------------- WHITESPACE / INDENTATION -------------------------------
" allow filetypes to have unique indentation settings
" apparently, this is needed for UltiSnips to work properly
filetype plugin indent on

" tabs are 4 spaces. end of discussion.
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" automatically indent
set autoindent

" don't wrap lines
set nowrap

" show whitespace
set nolist
set listchars=tab:???-,eol:???,trail:???

" whitespace test:


" -------------------- FILE NAVIGATION ----------------------------------------
"  NOTE: This command might be outdated. Try `cd %:h` if you still need it.
"set autochdir


" -------------------- SEARCH -------------------------------------------------
" highlight search results
set hlsearch

" show partial matches for searches
set incsearch


" -------------------- MAPPINGS -----------------------------------------------
" map ENTER to insert new line (after current line) and exit insert mode
nmap <CR> o<Esc>

" same mapping with SHIFT+ENTER to insert new line before current line
nmap <S-Enter> O<Esc>

" map CTRL+n to open NERDTree
map <silent> <C-n> :NERDTreeToggle<CR>

" map jj to Escape for easier switching out of insert mode
inoremap jj <Esc>

