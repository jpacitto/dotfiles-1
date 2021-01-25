call plug#begin('~/.vim/plugged')
Plug 'https://github.com/joshdick/onedark.vim' "colorscheme
Plug 'morhetz/gruvbox' "colorcheme
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim' " fuzzy finder (searching)
Plug 'https://github.com/scrooloose/nerdtree' "filesystem window
Plug 'Xuyuanp/nerdtree-git-plugin' "git flags for nerdtree (above)
Plug 'airblade/vim-gitgutter' "sidebar notifications when you've modified a line
Plug 'tomtom/tcomment_vim' "shortcuts for commenting out lines based on language used
Plug 'Lokaltog/vim-easymotion' "jumping around the file more easily using unique identifiers
Plug 'unblevable/quick-scope' "highlights unique letters in a line so that you can use f and t more effectively
Plug 'sheerun/vim-polyglot' "syntax for a lot of languages
Plug 'neoclide/coc.nvim', {'branch': 'release'} "intellisense for vim
Plug 'tpope/vim-surround' "easy delete, change, add surroundings in pairs
Plug 'Raimondi/delimitMate' "auto close parentheses, brackets, quotes
Plug 'tpope/vim-fugitive' "built in git support
Plug 'vim-airline/vim-airline' "tells you what branch you're in
Plug 'kshenoy/vim-signature' "displaying marks
Plug 'mattn/emmet-vim' "displaying marks
call plug#end()

if (empty($TMUX))
    if (has("nvim"))
        "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    endif
    "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
    "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
    " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
    if (has("termguicolors"))
        set termguicolors
    endif
endif
"if you don't have this, alacritty won't display vim colorschemes
if &term == "alacritty"
    let &term = "xterm-256-color"
endif

syntax enable "enable syntax highlighting
" filetype plugin indent on 
colorscheme onedark
" colorscheme gruvbox
set list "show everything except a space as distinct characters
set listchars=tab:>- "display tabs as > followed by as many '-'s as necessary
set background=dark

set number "show line numbers
set relativenumber "when combined with above, show relative numbers except for the current line
set ruler                                                                                                                                                                                    
set ttymouse=sgr "so that you can use the mouse to resize splits with alacritty
set laststatus=2 "always display the status line even if there's only one window
set mouse=a "enable mouse use
set hlsearch " highlight search

set ignorecase "case insensitive search
set smartcase "override 'ignorecase' if search contains capital letters

set expandtab "convert tabs to spaces. Use ctrl-v + tab to do a real tab char
set tabstop=4
set softtabstop=4
set shiftwidth=4

set backspace=indent,eol,start "otherwise can't backspace past the character at which insert mode was opened
set autoindent "copy indent from current line when starting a new line
set confirm "instead of failing a command due to unsaved changes, open a dialogue asking to save
set visualbell "use a visual bell instead of beeping when doing something wrong
set cmdheight=2 "set command window height to 2 lines so you never have to press enter to continue
set history=10000 "increase saved command history 
set showcmd "show imcomplete commands                                                                                                                                                                                                        
set modelines=0 "disable this for security sake
set nomodeline "disable this for security sake

"open new panes to the right and bottom, which is more natural than the default
set splitbelow
set splitright

set tw=110 "make the width of a 'line' bigger than the default
set updatetime=250 "for git gutter, so when a change is made we see it faster than the 4s default

set hidden "added this so that coc will work properly
set signcolumn=yes

packadd termdebug "load the termdebug package (gdb debuggind)
" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap ; :
nnoremap : ;
nnoremap <C-A> G$vgg
" map <Leader> <Plug>(easymotion-prefix) 

" Command mode remaps
command NTT :NERDTreeToggle
command NTM :NERDTreeMirror
command F :Files
command TN :tabnew

let mapleader=" " "space as a leader key (default is backspace)
" mappings for coc
nmap <silent> <leader>lp <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>ln <Plug>(coc-diagnostic-next)

nmap <silent> <leader>ld <Plug>(coc-definition)
nmap <silent> <leader>ly <Plug>(coc-type-definition)
nmap <silent> <leader>li <Plug>(coc-implementation)
nmap <silent> <leader>lr <Plug>(coc-references)

nmap <leader>lr <Plug>(coc-rename)
nnoremap <silent> K :call <SID>show_documentation()<CR> "function at bottom

" in visual mode, p will delete selection and paste implicit register
vnoremap <leader>p "_dP

" Trigger a highlight in the appropriate direction when pressing these keys for the quick scope plugin
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:termdebug_wide=1 "force term debug to load in vertical configuration
" show hidden files in nerd tree
let NERDTreeShowHidden=1

" func below is to easily show difference since last save
function! s:DiffWithSaved()
    let filetype=&ft
    diffthis
    vnew | r # | normal! 1Gdd
    diffthis
    exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

function! s:show_documentation()
    if &filetype == 'vim'
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

