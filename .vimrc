call plug#begin('~/.vim/plugged')
Plug 'https://github.com/joshdick/onedark.vim' "colorscheme
Plug 'morhetz/gruvbox' "colorcheme
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim' " fuzzy finder (searching)
Plug 'https://github.com/itchyny/lightline.vim' "colored mode line at the bottom
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

syntax on "enable syntax highlighting
colorscheme onedark
"colorscheme gruvbox

set number "show line numbers
set relativenumber "when combined with above, show relative numbers except for the current line
set ruler                                                                                                                                                                                    
set laststatus=2 "always display the status line even if there's only one window
set mouse=a
set hlsearch
set expandtab
set ignorecase "case insensitive search, except when using capital letters
set smartcase

"tab settings for linux kernel, but instead of 8 columns uses only 4
set tabstop=4
set softtabstop=4
set noexpandtab "hitting tab in insert mode will apply the appropriate number of spaces
set shiftwidth=4
set backspace=indent,eol,start "otherwise can't backspace past the character at which insert mode was opened
set autoindent
set confirm "instead of failing a command due to unsaved changes, open a dialogue asking to save
set visualbell "use a visual bell instead of beeping when doing something wrong
set cmdheight=2 "set command window height to 2 lines so you never have to press enter to continue
set history=10000
set showcmd "show imcomplete commands                                                                                                                                                                                                        
set modelines=0 "disable this for security sake
set nomodeline "disable this for security sake

"open new panes to the right and bottom, which is more natural than the convention
set splitbelow
set splitright
set tw=110 "make the width of a line bigger than the default
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
" map <Leader> <Plug>(easymotion-prefix) 

" Command mode remaps
command NTT :NERDTreeToggle
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

" Trigger a highlight in the appropriate direction when pressing these keys for the quick scope plugin
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:termdebug_wide=1 "force term debug to load in vertical configuration
" code to set the font for vim
if has("gui_running")
		if has("gui_gtk2")
                set guifont=Inconsolata\ 12
        elseif has("gui_macvim")
                set guifont=Menlo\ Regular:h14
        elseif has("gui_win32")
                set guifont=Consolas:h11:cANSI
        endif
endif

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

