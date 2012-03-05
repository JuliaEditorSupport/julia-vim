" NOTE: this line fixes an issue with the default system-wide lisp ftplugin
"       which doesn't define b:undo_ftplugin
"       (*.jt files are recognized as lisp)
au BufRead,BufNewFile *.jl		let b:undo_ftplugin = "setlocal comments< define< formatoptions< iskeyword< lisp<"

au BufRead,BufNewFile *.jl		set filetype=julia
