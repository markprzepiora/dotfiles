function! CopyFilename()
  silent execute "!echo -n '" . expand("%") . "' | pbcopy"
endfunction
:command CopyFilename call CopyFilename()

function! DeleteCassettes()
  silent execute "!vcr-cassettes-used '" . expand("%") . "' | grep 'yml$' | xargs --no-run-if-empty rm"
endfunction
:command DeleteCassettes call DeleteCassettes()
