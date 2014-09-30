if v:version < 704
  " NOTE: this line fixes an issue with the default system-wide lisp ftplugin
  "       which didn't define b:undo_ftplugin on older Vim versions
  "       (*.jl files are recognized as lisp)
  autocmd BufRead,BufNewFile *.jl    let b:undo_ftplugin = "setlocal comments< define< formatoptions< iskeyword< lisp<"
endif

autocmd BufRead,BufNewFile *.jl      set filetype=julia

autocmd BufEnter *                   call LaTeXtoUnicode#Refresh()
autocmd FileType *                   call LaTeXtoUnicode#Refresh()

" This autocommand is used to postpone the first initialization of LaTeXtoUnicode as much as possible,
" by calling LaTeXtoUnicode#SetTab amd LaTeXtoUnicode#SetAutoSub only at VimEnter or later
autocmd VimEnter *                   let g:l2u_did_vim_enter = 1 | call LaTeXtoUnicode#Init(0)
