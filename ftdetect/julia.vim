if v:version < 704
  " NOTE: this line fixes an issue with the default system-wide lisp ftplugin
  "       which didn't define b:undo_ftplugin on older Vim versions
  "       (*.jl files are recognized as lisp)
  autocmd BufRead,BufNewFile *.jl    let b:undo_ftplugin = "setlocal comments< define< formatoptions< iskeyword< lisp<"
endif

autocmd BufRead,BufNewFile *.jl      set filetype=julia

autocmd BufEnter *                   call LaTeXtoUnicode#Refresh()
autocmd FileType *                   call LaTeXtoUnicode#Refresh()

autocmd VimEnter *                    call LaTeXtoUnicode#Init()

" This autocommand is used to postpone the first initialization of LaTeXtoUnicode as much as possible,
" by calling LaTeXtoUnicode#SetTab amd LaTeXtoUnicode#SetAutoSub only at InsertEnter or later
augroup L2UInit
  autocmd InsertEnter *                   let g:did_insert_enter = 1 | call LaTeXtoUnicode#Init(0)
augroup END
