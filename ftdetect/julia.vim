if v:version < 704
  " NOTE: this line fixes an issue with the default system-wide lisp ftplugin
  "       which didn't define b:undo_ftplugin on older Vim versions
  "       (*.jl files are recognized as lisp)
  au BufRead,BufNewFile *.jl		let b:undo_ftplugin = "setlocal comments< define< formatoptions< iskeyword< lisp<"
endif

au BufRead,BufNewFile *.jl		set filetype=julia

au VimEnter * let g:julia_did_vim_enter = 1
