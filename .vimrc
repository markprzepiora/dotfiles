""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/bundle')

" Vim Markdown runtime files
Plug 'tpope/vim-markdown'

" Add-on to Tim Pope's markdown.vim to highlight using Github Flavored Markdown
Plug 'jtratner/vim-flavored-markdown'

" commentary.vim: comment stuff out
Plug 'tpope/vim-commentary'

" rails.vim: Ruby on Rails power tools
Plug 'tpope/vim-rails'

" includes syntax highlighting, indentation, omnicompletion, and various
" useful tools and mappings.
Plug 'vim-ruby/vim-ruby'

" fugitive.vim: A Git wrapper so awesome, it should be illegal
Plug 'tpope/vim-fugitive'

" unimpaired.vim: Pairs of handy bracket mappings
Plug 'tpope/vim-unimpaired'

" Vim script for text filtering and alignment
Plug 'godlygeek/tabular'

" Vastly improved Javascript indentation and syntax support in Vim
Plug 'vieira/vim-javascript', { 'for': ['js', 'javascript'] }

" TypeScript syntax
Plug 'leafgarland/typescript-vim'

" React JSX syntax highlighting and indenting for vim
Plug 'mxw/vim-jsx', { 'for': ['js', 'jsx', 'javascript'] }

" surround.vim: quoting/parenthesizing made simple
Plug 'tpope/vim-surround'

" repeat.vim: enable repeating supported plugin maps with "."
Plug 'tpope/vim-repeat'

" Start a * or # search from a visual block
Plug 'bronson/vim-visual-star-search'

" EditorConfig plugin for Vim
Plug 'editorconfig/editorconfig-vim'

" extended % matching for HTML, LaTeX, and many other languages
Plug 'tmhedberg/matchit'

" UltiSnips - The ultimate snippet solution for Vim
Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<c-b>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsEnableSnipMate = 0
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']

" abolish.vim: easily search for, substitute, and abbreviate multiple variants of a word
Plug 'tpope/vim-abolish'

" Color scheme
Plug 'nightsense/stellarized'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
" Despite the name, this one actually works with vanilla vim 9.0+ as well
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

" PowerShell highlighting
Plug 'PProvost/vim-ps1'

" ctags automation - https://github.com/ludovicchabant/vim-gutentags
" https://github.com/ludovicchabant/vim-gutentags/issues/277#issuecomment-635541116
Plug 'ludovicchabant/vim-gutentags', { 'commit': '31c0ead' }
let g:gutentags_ctags_exclude=['.git', 'vendor', 'tmp', '.bundle']

" Automatically deal with (*#@$ swap file messages
Plug 'gioele/vim-autoswap'
let g:autoswap_detect_tmux = 1

" An alternative sudo.vim for Vim and Neovim, limited support sudo in Windows
Plug 'lambdalisue/suda.vim'
let g:suda_smart_edit = 1

" Handlebars highlighting
Plug 'joukevandermaas/vim-ember-hbs'

" GitHub Copilot
Plug 'github/copilot.vim', { 'branch': 'release' }

" Better navigation between vim splits and tmux panes
Plug 'christoomey/vim-tmux-navigator'

if has('nvim')
  " Fuzzy finder
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'folke/flash.nvim', { 'branch': 'main' }
endif

call plug#end()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
" allow unsaved background buffers and remember marks/undo for them
set hidden
" remember more commands and search history
set history=10000
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set laststatus=2
set showmatch
set incsearch
set hlsearch
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
" highlight current line
set cursorline
set cmdheight=2
set switchbuf=useopen
set numberwidth=5
set number
set showtabline=2
set winwidth=120
" This makes RVM work inside Vim. I have no idea why.
set shell=bash
" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=
" keep more context when scrolling off the end of a buffer
set scrolloff=3
" Store temporary files in a central spot
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" display incomplete commands
set showcmd
" Enable highlighting for syntax
syntax on
" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin on
" use emacs-style tab completion when selecting files, etc
set wildmode=longest,list
" make tab completion for files/buffers act like bash
set wildmenu
let mapleader=","


" Try to fix slow syntax highlighting
set re=1
set nocursorcolumn
set nocursorline
syntax sync minlines=256

set wildignore+=public/system/**,.git,.svn,tmp/**
set wildignore+=bower_components/**,public/uploads/photo,node_modules/**,frontend/node_modules/**

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom Autocmds
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=78
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " For ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType ruby setlocal indentkeys-=.
  autocmd FileType python set sw=4 sts=4 et

  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

  " Indent p tags
  " autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off

  autocmd BufRead *.md nnoremap <buffer> k gk
  autocmd BufRead *.md nnoremap <buffer> j gj

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()

  autocmd FileType autohotkey setlocal commentstring=;\ %s
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
syntax enable

set background=dark

" These only make sense when the colorscheme is disabled:
"
"     hi MatchParen           cterm=none  ctermbg=6     ctermfg=8
"     hi Cursor                           ctermbg=blue  ctermfg=blue  gui=none
"     hi CursorLine term=none cterm=none  ctermbg=23

if has('nvim')
  set termguicolors
  " colorscheme onehalfdark
  colorscheme catppuccin-macchiato
else
  :set t_Co=256 " 256 colors
  colorscheme stellarized
endif

" Highlight the current line.
set cursorline


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Status Line
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc Key Maps
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" macOS
if has('macunix')
    map <leader>y "*y
    map <leader>p "*p
" WSL
elseif !empty(glob("/mnt/c"))
    " We used to use xsel to copy and paste but this only works when running
    " an X server, not if you are using the native ubuntu.exe / wsl.exe
    " terminal (or hyperfine) which is a problem. So instead we use clip.exe
    " and paste.exe.
    function! CopyTextWSL()
      normal gv"*y
      :call system('echo -n ' . shellescape(getreg('*')) . ' | xclip -selection clipboard -in')
    endfunction
    xmap <leader>y <esc>:call CopyTextWSL()<cr>
    map <leader>p :read !~/Dropbox/bin/windows/paste.exe<cr>
" Other Linux/Unix
elseif has('unix')
    " work-around to copy selected text to system clipboard
    " and prevent it from clearing clipboard when using ctrl+z (depends on xsel)
    function! CopyTextLinux()
      normal gv"*y
      :call system('xsel -ib', getreg('*'))
    endfunction
    xmap <leader>y <esc>:call CopyTextLinux()<Cr>
    map <leader>p "*p
endif

" WSL yank support
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
endif

" ,cn copies the current file basename to the unnamed buffer
nmap <leader>cn :let @" = expand('%:t:r')<cr>

function! ReplaceThisFile()
  " Replace all instances of __THISFILE__ with the current filename
  " Replace all instances of __THISBASENAME__ with the current filename's
  " basename
  let thisfile = expand('%')
  let thisbasename = expand('%:t:r')
  let thisfileescaped = escape(thisfile, '\/')
  let thisbasenameescaped = escape(thisbasename, '\/')
  execute '%s/__THISFILE__/' . thisfileescaped . '/ge'
  execute '%s/__THISBASENAME__/' . thisbasenameescaped . '/ge'
endfunction
:command! ReplaceThisFile :call ReplaceThisFile()

" do not automatically copy visual selections to the clipboard
set clipboard-=autoselect

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Open new splits to the right/below the current one instead of the left/above
set splitbelow
set splitright

" Use gF to open the matching file in a new vsplit
map gF :vert sfind <Plug><cfile><CR>

" Insert a hash rocket with <c-l>
imap <c-l> <space>=><space>

" Can't be bothered to understand ESC vs <c-c> in insert mode
imap <c-c> <esc>

" Clear the search buffer when hitting return
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()

" Switch between the current and previously-opened file with ,,
nnoremap <leader><leader> <c-^>

" Pasting over a visual selection no longer yanks the selection
xnoremap p P

" Center the screen when jumping to the next match
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Shift-H and Shift-L to move to the beginning and end of the line
nnoremap <S-h> ^
onoremap <S-h> ^
xnoremap <S-h> ^
nnoremap <S-l> g_
onoremap <S-l> g_
xnoremap <S-l> g_

" Toggle wrap with <leader>w
nnoremap <leader>w :set wrap!<cr>

" Delete visual selection with <cr>
vnoremap <cr> d

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Multipurpose Tab Key
"
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable arrow keys
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Open files in directory of current file with ,e
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap %% <C-R>=expand('%:h').'/'<cr>
nmap <leader>e :edit %%
nmap <leader>v :view %%


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Extract a variable from the current visual selection
"
" Usage:
"
"     notify(Account.find(123).users)
"            ^^^^^^^^^^^^^^^^^
"
" Carets indicate the visual selection.
"
" Press ,e and enter 'account' when prompted.
"
" Result:
"
"     account = Account.find(123)
"     notify(account.users)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! ExtractVariableFromSelection()
  let var_name = input('Variable name: ', '')
  execute ':normal! gvxmqi' . var_name . "\<esc>O\<esc>PI" . var_name . " = \<esc>==`q"
endfunction
vmap <leader>e :call ExtractVariableFromSelection()<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Rename current file with <leader>n
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFileAsk()
    let new_name = input('New file name: ', expand('%'), 'file')
    call RenameFileTo(new_name)
endfunction

function! RenameFileTo(new_name)
    let old_name = expand('%')
    call RenameFile(old_name, a:new_name)
endfunction

function! RenameFile(old_name, new_name)
    if a:new_name != '' && a:new_name != a:old_name
        exec ':saveas ' . a:new_name
        exec ':silent !rm ' . a:old_name
        redraw!
    endif
endfunction

map <leader>n :call RenameFileAsk()<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Promote variable to RSpec 'let'
"
" Example:
"
"   foo = do('bar')
"
" Output:
"
"   let(:foo) { do('bar') }
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let!(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
augroup PromoteTolet
  autocmd!
  autocmd FileType ruby nnoremap <buffer> <leader>l :PromoteToLet<cr>
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Promote variable to RSpec 'let' (visual block mode)
"
" Example:
"
"   foo = do_something({
"     'bar' => 'baz'
"   })
"
" Use V to select the block, then <leader>l to promote it.
"
" Output:
"
"   let(:foo) do
"     do_something({
"       'bar' => 'baz'
"     })
"   end
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PromoteToLetVisual()
  let @l = '`<f=��awv`>h"kx0elDIlet(:jkA) doendjkkojk��a"kpgvj0k$V%koj='
  normal @l
endfunction
:command! PromoteToLetVisual :call PromoteToLetVisual()
autocmd FileType ruby vmap <leader>l <Esc>:PromoteToLetVisual<cr>

" <leader>me to wrap a block in a .each block
autocmd FileType ruby nmap <leader>me yiwA.each do \|<esc>pxa\|<cr>end<esc>O
" <leader>mE to wrap a block in a .each block and also leave a comment for use
" in my code notebook when walking through code
autocmd FileType ruby nmap <leader>mE "gyiwA.each do \|<esc>"gpxa\|<cr>end<esc>O# <esc>"gp==$xA = <esc>"gpa[0]<cr><esc>xA
" <leader>me to wrap a block in a .map block
autocmd FileType ruby nmap <leader>mm yiwA.map do \|<esc>pxa\|<cr>end<esc>O
" <leader>mE to wrap a block in a .map block and also leave a comment for use
" in my code notebook when walking through code
autocmd FileType ruby nmap <leader>mM "gyiwA.map do \|<esc>"gpxa\|<cr>end<esc>O# <esc>"gp==$xA = <esc>"gpa[0]<cr><esc>xA


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Automatically set relativenumber
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

:set relativenumber


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fix fucking :w, :q, and :e typos
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

:command WQ wq
:command Wq wq
:command Wa wa
:command W w
:command Q q
:command Qa qa
:command! -bar -bang Q quit<bang>
:command! -bar -bang Qa qall<bang>
:command! -nargs=* -bang -complete=file E e<bang> <args>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Jump to Gemfile
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>gg :topleft 100 :split Gemfile<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app =
        \ match(current_file, '\<rallio\>') != -1 ||
        \ match(current_file, '\<controllers\>') != -1 ||
        \ match(current_file, '\<models\>') != -1 ||
        \ match(current_file, '\<views\>') != -1 ||
        \ match(current_file, '\<helpers\>') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    else
      let new_file = substitute(new_file, '^lib/', '', '')
    end
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    if in_app
      let new_file = 'app/' . new_file
    else
      let new_file = 'lib/' . new_file
    end
  endif
  return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>t :call RunTestFile()<cr>
map <leader>r :call RunTests('')<cr>
map <leader>T :call RunNearestTest()<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file = @%
    let t:grb_test_file = fnamemodify(expand(t:grb_test_file), ":~:.")
endfunction

function! GetTestRunner(filename)
    let is_rspec_file = match(a:filename, '_spec.rb$') != -1
    let is_minitest_file = match(a:filename, '_test.rb$') != -1
    let is_rails_minitest_project = !empty(glob('test')) && filereadable('config.ru') && match(readfile('config.ru'), 'Rails') != -1
    let is_other_minitest_project = !empty(glob('test')) && filereadable('Gemfile') && match(readfile('Gemfile'), '\v<minitest>') != -1
    let is_rspec_project = !empty(glob('spec')) && filereadable('Gemfile') && match(readfile('Gemfile'), '\v<rspec>') != -1

    " The easy cases are when there's a test runner in the script or test
    " directories -- if so, just use it!
    if filereadable("script/test")
        return ["script/test"]
    elseif filereadable("bin/test")
        return ["bin/test"]
    elseif filereadable("bin/rspec")
        return ["bin/rspec", "--color"]

    " Rails minitests are run with the `bin/rails test` command, which allows
    " for running single test files!
    elseif is_rails_minitest_project
        return ["bin/rails", "test"]

    " If it's a non-Rails minitest project, try just running the test with ruby???
    elseif is_other_minitest_project
        return ["bundle", "exec", "ruby"]

    " If it's a Gemfile-based rspec project, run it with bundle.
    elseif is_rspec_project
        return ["bundle", "exec", "rspec", "--color"]

    " Otherwise who knows, run global rspec and pray.
    else
        return ["rspec", "--color"]
    end
endfunction!

" Exit to normal mode inside a terminal with escape
if has('nvim')
  tnoremap <Esc> <C-\><C-n>
endif

function! RunTests(filename)
    " Write the file and run tests for the given filename
    if strlen(expand("%")) > 0
      :w
    end
    let test_cmd = GetTestRunner(a:filename)

    if strlen(a:filename) > 0
      call add(test_cmd, a:filename)
    end

    let existing_buffer = bufwinnr('\[test_runner\]')
    if existing_buffer >= 0
      exe existing_buffer . "wincmd w"
      :q
    end

    botright new
    resize 8
    set nonumber
    set norelativenumber

    if has('nvim')
      call termopen(test_cmd)
    else
      call term_start(test_cmd, { 'term_finish': 'open', 'curwin': 1, 'term_name': '[test_runner] ' . join(test_cmd, " ") })
    endif

    au BufLeave <buffer> wincmd p
    nnoremap <buffer> <Enter> :q<CR>
    wincmd p
    redraw
    echo "Press <Enter> to exit test runner terminal (<Ctrl-C> first if command is still running)"
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Wrapping stuff in HTML/Handlebars
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Wrap visual selection in a Handlebars tag.
" http://vim.wikia.com/wiki/Wrap_a_visual_selection_in_an_HTML_tag
vmap <Leader>W <Esc>:call VisualHTMLTagWrap()<CR>
function! VisualHTMLTagWrap()
  let tag = input("Tag to wrap block: ")
  if len(tag) > 0
    normal `>
    if &selection == 'exclusive'
      exe "normal O</".tag.">"
    else
      exe "normal a</".tag.">"
    endif
    normal `<
    exe "normal i<".tag.">"
    normal `<
  endif
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sudo write with w!!
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

cmap w!! w !sudo tee > /dev/null %


" Set shiftwidth to 2 for formats that have different defaults
au BufNewFile,BufReadPost *.handlebars setl shiftwidth=2 expandtab
au BufNewFile,BufReadPost *.md setl shiftwidth=2 expandtab

" Allow auto-completion of names with dashes in CSS and HTML (useful for class
" names)
au BufNewFile,BufReadPost *.css,*.scss,*.html,*.handlebars,*.hbs,*.html.erb setl iskeyword+=-

" jj exits insert mode
imap jj <esc>
" jk exits insert mode
imap jk <esc>

" Toggle relative/absolute numbers with C+n
function! NumberToggle()
  if(&relativenumber == 1)
    set nonumber
    set norelativenumber
  else
    set number
    set relativenumber
  endif
endfunc
nnoremap <C-n><C-n> :call NumberToggle()<cr>

" Toggle folds with space
nnoremap <Space> za


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tabularize shortcuts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <Leader>a= :Tabularize /^[^=]*\zs=/l1c1l0<CR>
vmap <Leader>a= :Tabularize /^[^=]*\zs=/l1c1l0<CR>
nmap <Leader>a: :Tabularize /^[^:]*:\zs/l1l0<CR>
vmap <Leader>a: :Tabularize /^[^:]*:\zs/l1l0<CR>
nmap <Leader>a> :Tabularize /=><CR>
vmap <Leader>a> :Tabularize /=><CR>
nmap <Leader>a, :Tabularize /,\zs<CR>
vmap <Leader>a, :Tabularize /,\zs<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commentary Shortcuts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Comment out lines of code with \ <motion>
nmap \ gc

" Comment out a single line of code with \\
nmap \\ gcc

" Comment out a visual selection with \
vmap \ gc

" Select the current line's indent level
function SelectIndent()
  let cur_line = line(".")
  let cur_ind = indent(cur_line)
  let line = cur_line
  while indent(line - 1) >= cur_ind
    let line = line - 1
  endw
  exe "normal " . line . "G"
  exe "normal V"
  let line = cur_line
  while indent(line + 1) >= cur_ind
    let line = line + 1
  endw
  exe "normal " . line . "G"
endfunction

" Select the current line's indent level with ,i
map <leader>i :call SelectIndent()<cr>

if has('nvim')
  let g:markdown_fenced_languages = ['sql', 'ruby', 'js=javascript']
else
  augroup markdown
    au!
    au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
  augroup END
endif

augroup yaml
  au!
  au BufNewFile,BufRead *.yml setlocal syntax=off
augroup END

" <Ctrl-p> Acts like the opposite of D, it pastes, deleting the rest of the
" current line with the buffer, with the added bonus of not yanking at the
" same time.
nnoremap <C-p> vg_"_xp

" Joining lines with Shift+J removes leading comments.
set formatoptions+=j

" ,d duplicates the block under the cursor
nmap <leader>d V%y`>o<esc>p

" ,; adds a semicolon to the end of the current line and moves down
nnoremap <leader>; A;<esc>j

" alt+backspace to delete words in insert mode as expected
imap <Esc><BS> <C-w>

" If you like `Y` to work from the cursor to the end of line (which is more
" logical, but not Vi-compatible) use `:map Y y$`.
map Y y$


"""""""""""""""""""""""""""""""""""""
" Ruby indentation personalizations "
"""""""""""""""""""""""""""""""""""""

" x = if condition
"   something
" end
let g:ruby_indent_assignment_style = 'variable'

" render('product/show',
"   product: product,
"   on_sale: true,
" )
let g:ruby_indent_hanging_elements = 0

let g:copilot_filetypes = {
      \ 'gitcommit': v:true,
      \ }
