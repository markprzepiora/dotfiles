" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.
function! SelectaCommand(choice_command, selecta_args, vim_command)
  if has('macunix')
    let l:selecta = $HOME . '/dotfiles/bin/fzy-osx'
  elseif has('unix')
    let l:selecta = $HOME . '/dotfiles/bin/fzy-linux'
  endif

  try
    let l:selection = system(a:choice_command . " | " . l:selecta . " 2>/dev/null " . a:selecta_args)
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . l:selection
endfunction

function SelectaInsert(cmd, selecta_args)
  if has('macunix')
    let l:selecta = $HOME . '/dotfiles/bin/fzy-osx'
  elseif has('unix')
    let l:selecta = $HOME . '/dotfiles/bin/fzy-linux'
  endif

  try
    let l:selection = system(a:cmd . " | " . l:selecta . " 2>/dev/null " . a:selecta_args)
    let l:selection = substitute(l:selection, '\n\+$', '', '')
    let l:selection = substitute(l:selection, '^\n\+', '', '')
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  normal o
  exec ":normal i" . l:selection
  exec ":normal =="
endfunction

:command Req call SelectaInsert("~/dotfiles/bin/util/rails-js-require", "")
:command Let call SelectaInsert("~/dotfiles/bin/util/rails-js-let", "")

" Find all files in all non-dot directories starting in the working directory.
" Fuzzy select one of those. Open the selected file with :e.
nnoremap <leader>f :call SelectaCommand("find_src_files", "", ":e")<cr>

" Find only production files (exclude tests)
nnoremap <leader>cp :call SelectaCommand("find_src_files \| grep -vE '^(spec\|test)/'", "", ":e")<cr>

" Find only tests (exclude production files)
nnoremap <leader>ct :call SelectaCommand("find_src_files \| grep -E '^(spec\|test)/'", "", ":e")<cr>

" Find files in the current file's directory
nnoremap <leader>F :call SelectaCommand("find_src_files \| grep -F '" . expand('%:h') . "'", "", ":e")<cr>

" Find what are other, probably related files.
nnoremap <leader>C :call SelectaCommand("find_src_files \| ~/dotfiles/bin/filter_related_files " . expand('%'), "", ":e")<cr>

" These two are a bit different. Mark uses these to try to find where an Ember
" class is defined. If the word under the cursor is FooBar then this will
" search for the regex /\vFooBar *=/
"
" Eventually I want to make this a little more generalized to replace gf with
" something smarter.
nnoremap <leader>cd "zyiw:call SelectaCommand("rg -il '\\b" . @z . " *='", "", ":e")<cr>
vnoremap <leader>cd "zy:call SelectaCommand("rg -il '\\b" . @z . " *='", "", ":e")<cr>

" Visually-selecting some text and pressing ,f searches for a filename with
" that string. Useful for finding some files that ctags don't find.
:vmap <leader>f <esc>:call SelectaSearchForSelection()<cr>
function! SelectaSearchForSelection()
  normal gv"*y
  call SelectaCommand("find_src_files", "-q " . getreg('*'), ":e")
endfunction

" Visually-selecting some text and pressing ,a searches for a file containing
" that string.
:vmap <leader>a <esc>:call SelectaSearchForSelectionContents()<cr>
function! SelectaSearchForSelectionContents()
  normal gv"*y
  call SelectaCommand("ag -lQ " . shellescape(getreg('*')), "", ":e")
endfunction
