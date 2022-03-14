function! CopyFilename()
  silent execute "!echo -n '" . expand("%") . "' | pbcopy"
endfunction

:command CopyFilename call CopyFilename()
