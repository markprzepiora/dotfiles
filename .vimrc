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

" fugitive.vim: A Git wrapper so awesome, it should be illegal
Plug 'tpope/vim-fugitive'

" unimpaired.vim: Pairs of handy bracket mappings
Plug 'tpope/vim-unimpaired'

" Vim script for text filtering and alignment
Plug 'godlygeek/tabular'

" Vastly improved Javascript indentation and syntax support in Vim
Plug 'pangloss/vim-javascript', { 'for': ['js', 'javascript'] }

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

" abolish.vim: easily search for, substitute, and abbreviate multiple variants of a word
Plug 'tpope/vim-abolish'

" Vim plugin for the_silver_searcher, 'ag'
Plug 'rking/ag.vim'

" Easier ag searching
Plug 'Chun-Yang/vim-action-ag'

" Color scheme
Plug 'nightsense/stellarized'

" Big bundle of color schemes
Plug 'flazz/vim-colorschemes'

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
  autocmd FileType python set sw=4 sts=4 et

  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

  " Indent p tags
  " autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
:set t_Co=256 " 256 colors

syntax enable
set background=dark

" These only make sense when the colorscheme is disabled:
"
"     hi MatchParen           cterm=none  ctermbg=6     ctermfg=8
"     hi Cursor                           ctermbg=blue  ctermfg=blue  gui=none
"     hi CursorLine term=none cterm=none  ctermbg=23

" I like this colorscheme, especially with a couple of overrides
colorscheme delek
hi Search ctermbg=blue ctermfg=0
hi StatusLine ctermfg=8

" This one is pretty nice too.
"
"     colorscheme znake

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
    function! CopyText()
      normal gv"*y
      :call system('~/Dropbox/bin/windows/clip.exe', getreg('*'))
    endfunction
    xmap <leader>y <esc>:call CopyText()<cr>
    map <leader>p :read !~/Dropbox/bin/windows/paste.exe<cr>
" Other Linux/Unix
elseif has('unix')
    " work-around to copy selected text to system clipboard
    " and prevent it from clearing clipboard when using ctrl+z (depends on xsel)
    function! CopyText()
      normal gv"*y
      :call system('xsel -ib', getreg('*'))
    endfunction
    xmap <leader>y <esc>:call CopyText()<Cr>
    map <leader>p "*p
endif

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
map <leader>e :edit %%
map <leader>v :view %%


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Rename current file
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
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
augroup PromoteTolet
  autocmd!
  autocmd FileType ruby nnoremap <buffer> <leader>l :PromoteToLet<cr>
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" USEFUL GETTER MACRO FOR EMBER.JS APPLICATIONS
"
" Example:
"
"   foo
"   model.foo
"
" Output:
"
"   const foo = this.get('foo');
"   const foo = this.get('model.foo');
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! EmberGetter()
  :.s/\v^( *)((.+\.)?([^.]+)$)/\1const \4 = this.get('\2');/
  :normal! +
  silent! call repeat#set(",l", -1)  " Allow us to do it multiple times
endfunction
:command! EmberGetter :call EmberGetter()
augroup EmberGetter
  autocmd!
  autocmd FileType javascript nnoremap <buffer> <leader>l :EmberGetter<cr>
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Automatically set relativenumber
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

:set relativenumber


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fix fucking :w and :q typos
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

:command WQ wq
:command Wq wq
:command Wa wa
:command W w
:command Q q
:command Qa qa
:command! -bar -bang Q quit<bang>
:command! -bar -bang Qa qall<bang>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Jump to routes
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>gr :topleft :split config/routes.rb<cr>
function! ShowRoutes()
  " Requires 'scratch' plugin
  :topleft 100 :split __Routes__
  " Make sure Vim doesn't write __Routes__ as a file
  :set buftype=nofile
  " Delete everything
  :normal 1GdG
  " Put routes output in buffer
  :0r! rake -s routes
  " Size window to number of lines (1 plus rake output length)
  :exec ":normal " . line("$") . "_ "
  " Move cursor to bottom
  :normal 1GG
  " Delete empty trailing line
  :normal dd
endfunction
map <leader>gR :call ShowRoutes()<cr>


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
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') || match(current_file, '\<helpers\>') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    if in_app
      let new_file = 'app/' . new_file
    end
  endif
  return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number . " -b")
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    if match(a:filename, '\.feature$') != -1
        exec ":!script/cucumber " . a:filename
    else
        if filereadable("script/test")
            exec ":!script/test " . a:filename
        elseif filereadable("Gemfile")
            exec ":!bundle exec rspec --color " . a:filename
        else
            exec ":!rspec --color " . a:filename
        end
    end
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

" Wrap visual selection in a Handlebars tag.
" http://vim.wikia.com/wiki/Wrap_a_visual_selection_in_an_HTML_tag
vmap <Leader>w <Esc>:call VisualHandlebarsTagWrap()<CR>
function! VisualHandlebarsTagWrap()
  let tag = input("Tag to wrap block: ")
  if len(tag) > 0
    normal `>
    if &selection == 'exclusive'
      exe "normal O{{/".tag."}}"
    else
      exe "normal a{{/".tag."}}"
    endif
    normal `<
    exe "normal i{{#".tag."}}"
    normal `<
  endif
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Md5 COMMAND
" Show the MD5 of the current buffer
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -range Md5 :echo system('echo '.shellescape(join(getline(<line1>, <line2>), '\n')) . '| md5')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sudo write with w!!
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

cmap w!! w !sudo tee > /dev/null %


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OpenChangedFiles COMMAND
" Open a split for each dirty file in git
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenChangedFiles()
  only " Close all windows, unless they're modified
  let status = system('git status -s | grep "^ \?\(M\|A\|UU\)" | sed "s/^.\{3\}//"')
  let filenames = split(status, "\n")
  exec "edit " . filenames[0]
  for filename in filenames[1:]
    exec "sp " . filename
  endfor
endfunction
command! OpenChangedFiles :call OpenChangedFiles()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" InsertTime COMMAND
" Insert the current time
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>

set number
nmap <C-N><C-N> :set invnumber <CR>
" set smartindent
" set ic
" set scs
" map #2 <Esc><Plug>Traditionalji<Esc>
" set expandtab
" set tabstop=3
" set shiftwidth=3
" set ff=unix
" set hlsearch
" color torte
" color darkblue

" Set shiftwidth to 2 for coffeescript and handlebars files
au BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab
au BufNewFile,BufReadPost *.handlebars setl shiftwidth=2 expandtab

" Enable folding for coffeescript files
au BufNewFile,BufReadPost *.coffee setl foldmethod=indent nofoldenable

" Allow auto-completion of names with dashes in CSS and HTML (useful for class
" names)
au BufNewFile,BufReadPost *.css,*.scss,*.html,*.handlebars,*.hbs,*.html.erb setl iskeyword+=-

" jj exits insert mode
imap jj <esc>

" Toggle relative/absolute numbers with C+n
function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc
nnoremap <C-n> :call NumberToggle()<cr>

" Toggle folds with space
nnoremap <Space> za

" Set up eregex
" nnoremap / :M/ 
" nnoremap ,/ / 

" XMPfilter annotations
map <silent> <F8> !xmpfilter -a<cr>
nmap <silent> <F8> V<F10>
imap <silent> <F8> <ESC><F10>a

" Annotate the full buffer
" I actually prefer ggVG to %; it's a sort of poor man's visual bell 
nmap <silent> <F7> mzggVG!xmpfilter -a<cr>'z
" nmap <silent> <F7> mz%;!xmpfilter -a<cr>'z
imap <silent> <F7> <ESC><F7>



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

augroup markdown
  au!
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

augroup yaml
  au!
  au BufNewFile,BufRead *.yml setlocal syntax=off
augroup END

let g:UltiSnipsExpandTrigger="<c-b>"
let g:UltiSnipsEnableSnipMate = 0
