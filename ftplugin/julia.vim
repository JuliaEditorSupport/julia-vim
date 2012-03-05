" Vim filetype plugin file
" Language:	Julia
" Maintainer:	Carlo Baldassi <carlobaldassi@gmail.com>
" Last Change:	2011 dec 11

if exists("b:did_ftplugin")
	finish
endif

let b:did_ftplugin = 1

setlocal include="^\s*load\>"
setlocal suffixesadd=.jl
setlocal comments=:#
setlocal commentstring=#%s
setlocal define="^\s*macro\>"

" Uncomment the following line if you want operators to be
" syntax-highlightened
let g:julia_highlight_operators=1

" Uncomment the following two lines to force julia source-code style
setlocal shiftwidth=4
setlocal expandtab

if has("gui_win32")
	let b:browsefilter = "Julia Source Files (*.jl)\t*.jl\n"
endif

let b:undo_ftplugin = "setlocal include< suffixesadd< comments< commentstring< define< shiftwidth< expandtab<"
	\ . "| unlet! b:browsefiler"
