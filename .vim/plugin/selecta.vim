" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.
function! SelectaCommand(choice_command, selecta_args, vim_command)
  try
    let selection = system(a:choice_command . " | selecta 2>/dev/null" . a:selecta_args)
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

" Find all files in all non-dot directories starting in the working directory.
" Fuzzy select one of those. Open the selected file with :e.
nnoremap <leader>f :call SelectaCommand("find_src_files", "", ":e")<cr>

" Find only production files (exclude tests)
nnoremap <leader>cp :call SelectaCommand("find_src_files \| grep -vE '^\./(spec\|test)/'", "", ":e")<cr>

" Find only tests (exclude production files)
nnoremap <leader>ct :call SelectaCommand("find_src_files \| grep -E '^\./(spec\|test)/'", "", ":e")<cr>

" Find files in the current file's directory
nnoremap <leader>F :call SelectaCommand("find_src_files \| grep -F '" . expand('%:h') . "'", "", ":e")<cr>

" Find what are other, probably related files.
nnoremap <leader>C :call SelectaCommand("find_src_files \| ~/dotfiles/bin/filter_related_files " . expand('%'), "", ":e")<cr>
