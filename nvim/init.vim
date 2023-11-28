" Normal options {{{
" Absolutely esential {{{
filetype plugin indent on
set nocompatible

" }}}
" Basic {{{
scriptencoding utf-8
syntax on
set encoding=utf-8
set history=700
set autoread
set cursorline
set visualbell
set number
set relativenumber
set listchars=eol:$,tab:>-,trail:·,extends:❯,precedes:❮
set fillchars=diff:⣿,vert:│
set lazyredraw
set list
set ignorecase
set hidden
set incsearch
set mouse=a
set showmatch
set hlsearch
set matchtime=2
set fileformats=unix,dos,mac
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set laststatus=2
set showcmd
set autoindent
set backspace=indent,eol,start
set virtualedit=block
set nrformats-=octal
set dictionary=/usr/share/dict/words

" }}}
" WiLd menu stuff {{{
"
" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore+=.hg,.git,.svn " Version Control
set wildignore+=*.aux,*.out,*.toc " LaTeX intermedite files
set wildignore+=*~ " Bakcup files and stuff
set wildignore+=*.o " Compiled files
set wildignore+=__pycache__,*.pyc " Python compiled files

" }}}
" folding stuff {{{
" set fold method marker
set foldmethod=marker
" }}}
" }}}
" Confuration for plugins {{{
" Plug stuff {{{
call plug#begin('~/.config/nvim/plugged')

" My plugs here:
Plug 'vim-airline/vim-airline' " Make the bar prettier
Plug 'vim-airline/vim-airline-themes' " Load airline themes
Plug 'tpope/vim-fugitive' " Add awesome support for git
Plug 'airblade/vim-gitgutter' " Show deleted/added/modified tags for vim
Plug 'sjl/gundo.vim' " Undo and redo tree
Plug 'ctrlpvim/ctrlp.vim' " Fuzzy find for files
Plug 'benekastah/neomake' " Syntax checker
Plug 'Lokaltog/vim-easymotion' " Fast move inside vim
Plug 'justinmk/vim-sneak' " More magick s command
Plug 'majutsushi/tagbar', { 'on': 'TagbarOpen' } " Tags for coding
Plug 'tomtom/tcomment_vim' " Comment and uncomment code
Plug 'SirVer/ultisnips' " Tab completition when writing
Plug 'honza/vim-snippets' " Snippets for ultisnip
Plug 'godlygeek/tabular' " Tabularize with :Tab /{regex} or visual select and the same
Plug 'tpope/vim-surround' " Tpope surround plugin for improved surround tags
" Plug 'lervag/vimtex', { 'for': 'tex' } " Add latex support
Plug 'LnL7/vim-nix' " nix syntax highlight
Plug 'kshenoy/vim-signature' " Better bookmarks
Plug 'vim-scripts/django.vim'
Plug 'vim-scripts/listmaps.vim' " List maps
Plug 'luochen1990/rainbow' " Color different paretheses
Plug 'tpope/vim-repeat' " Improve the . repeat command
" Plug 'tkztmk/vim-vala' " Add syntax highlight for vala
Plug 'rust-lang/rust.vim' " Add syntax highlight for rust
Plug 'lambdatoast/elm.vim' " Elm extensions
" Plug 'phildawes/racer', { 'for': 'rust','do': 'cargo build --release'}
Plug 'chase/vim-ansible-yaml' " Add syntax highlight for ansible yaml
Plug 'vim-scripts/iptables' " Add syntax highlight for iptables
Plug 'rstacruz/sparkup' " Magic to create html
Plug 'cespare/vim-toml' " Because cargo.toml
Plug 'wellle/targets.vim' " provide additional text objects
Plug 'lambdalisue/suda.vim'
Plug 'hashivim/vim-terraform'
Plug 'elixir-editors/vim-elixir'
" Plug 'Yggdroot/indentLine' " Add indent lines with special char
" Plug 'FredKSchott/CoVim' " Peer programming he he he
" Plug 'terryma/vim-multiple-cursors' " Multiple cursors support
" Haskell {{{
" Plug 'eagletmt/neco-ghc' " completion from ghc-mod
" Plug 'eagletmt/ghcmod-vim' " ghcmod reasons
" }}}
" Colorschemes {{{
Plug 'sjl/badwolf' " badwolf
" Plug 'nanotech/jellybeans.vim' " jellybeans
" }}}

call plug#end()

" }}}
" syntastic {{{
" }}}
" deoplete {{{
let g:deoplete#enable_at_startup = 1
" }}}
" haskell {{{
" Disable haskell-vim omnifunc
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
" }}}
" ultisnips {{{
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" }}}
" vim-easy-align {{{
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
nmap <Leader>a <Plug>(EasyAlign)
" }}}
" vim-airline {{{
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='badwolf'
" }}}
" ctrlp.vim {{{
let g:ctrlp_map = '<leader>p'
let g:ctrlp_cmd = 'CtrlPLastMode'
let g:ctrlp_extensions = ['buffertag', 'tag', 'line', 'dir']
" }}}
" jedi-vim {{{
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#goto_assignments_command = "<leader>jg"
let g:jedi#goto_definitions_command = "<leader>jd"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>jn"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>jr"
"    }}}
" vim-bookmarks {{{
let g:bookmark_sign = '⚑'
let g:bookmark_annotation_sign = '#'
let g:bookmark_save_per_working_dir = 0
let g:bookmark_auto_save = 1
let g:bookmark_auto_save_file = $HOME .'/.vim-bookmarks'
let g:bookmark_auto_close = 0
let g:bookmark_highlight_lines = 0
let g:bookmark_show_warning = 1
let g:bookmark_center = 1
" highlight BookmarkSign ctermbg=255 ctermfg=255
" highlight BookmarkAnnotationSign ctermbg=255 ctermfg=255
" highlight BookmarkLine ctermbg=255 ctermfg=255
" highlight BookmarkAnnotationLine ctermbg=255 ctermfg=255
" }}}
" vim-indent-guides {{{
hi IndentGuidesOdd  ctermbg=234
hi IndentGuidesEven ctermbg=236

let g:indent_guides_auto_colors = 0
let g:indent_guides_start_level = 0
let g:indent_guides_guide_size = 1
" }}}
" }}}
" colorscheme {{{
colorscheme badwolf
"    }}}
" Mappings {{{

let mapleader = "\<space>"
nnoremap <CR> :

" Replace Esc for fd
imap fd <Esc>

" toggle paste with F2
set pastetoggle=<F2>

" Star search in visualmode
vnoremap * "ty/<C-R>t<CR>

" Set Y to como se debe
nnoremap H ^
nnoremap L $
nnoremap Y y$
nnoremap K <nop>
nnoremap <silent> S i<CR><esc>k:s/ \+$//<CR>$

" Tabs navigation
nmap <leader>b :bprevious<CR>
nmap <leader>n :bnext<CR>
nmap <leader>d :bdelete<CR>

" Folding focus
nnoremap <leader>z zMzvzz

" Train myself
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Forgot to sudo
command W w suda://%

" Move blocks of text around {{{
nnoremap <C-j> :m+<CR>==
nnoremap <C-k> :m-2<CR>==
nnoremap <C-h> <<
nnoremap <C-l> >>
inoremap <C-j> <Esc>:m+<CR>==gi
inoremap <C-k> <Esc>:m-2<CR>==gi
inoremap <C-h> <Esc><<`]a
inoremap <C-l> <Esc>>>`]a
" TODO make this better
vnoremap <C-j> :m'>+<CR>gv=gv
vnoremap <C-k> :m-2<CR>gv=gv
vnoremap <C-h> <gv
vnoremap <C-l> >gv
" }}}

" Highlight Word {{{
"
" This mini-plugin provides a few mappings for highlighting words temporarily.
"
" Sometimes you're looking at a hairy piece of code and would like a certain
" word or two to stand out temporarily.  You can search for it, but that only
" gives you one color of highlighting.  Now you can use <leader>N where N is
" a number from 1-6 to highlight the current word in a specific color.

function! HiInterestingWord(n) " {{{
    " Save our location.
    normal! mz
    " Yank the current word into the z register.
    normal! "tyiw
    " Calculate an arbitrary match ID.  Hopefully nothing else is using it.
    let mid = 86750 + a:n
    " Clear existing matches, but don't worry if they don't exist.
    silent! call matchdelete(mid)
    " Construct a literal pattern that has to match at boundaries.
    let pat = '\V\<' . escape(@t, '\') . '\>'
    " Actually match the words.
    call matchadd("InterestingWord" . a:n, pat, 1, mid)
    " Move back to our original location.
    normal! `z
endfunction " }}}
" Mappings {{{
nnoremap <silent> <leader>h1 :call HiInterestingWord(1)<CR>
nnoremap <silent> <leader>h2 :call HiInterestingWord(2)<CR>
nnoremap <silent> <leader>h3 :call HiInterestingWord(3)<CR>
nnoremap <silent> <leader>h4 :call HiInterestingWord(4)<CR>
nnoremap <silent> <leader>h5 :call HiInterestingWord(5)<CR>
nnoremap <silent> <leader>h6 :call HiInterestingWord(6)<CR>

nnoremap <silent> <leader>hc1 :call matchdelete(86751)<CR>
nnoremap <silent> <leader>hc2 :call matchdelete(86752)<CR>
nnoremap <silent> <leader>hc3 :call matchdelete(86753)<CR>
nnoremap <silent> <leader>hc4 :call matchdelete(86754)<CR>
nnoremap <silent> <leader>hc5 :call matchdelete(86755)<CR>
nnoremap <silent> <leader>hc6 :call matchdelete(86756)<CR>

nnoremap <silent> <leader>hcc :call clearmatches()<CR>

" Clear screen clears search highlighting.
noremap <leader>hc :let @/ = ""<CR>
" }}}
" Default Highlights {{{

hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195

" }}}
" }}}
" }}}
" Filetype-specific {{{
" Python {{{
" Set fold method to indent if filetype is python
autocmd filetype python setlocal foldmethod=indent
autocmd filetype python setlocal colorcolumn=80
" }}}
" gitcommit {{{
autocmd filetype gitcommit setlocal nofoldenable spell spelllang=en
" }}}
" vim {{{
autocmd filetype vim setlocal foldmethod=marker
" }}}
" djangohtml {{{
autocmd filetype htmldjango setlocal noexpandtab
" }}}
" }}}
