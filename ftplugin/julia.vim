" Vim filetype plugin file
" Language:	Julia
" Maintainer:	Carlo Baldassi <carlobaldassi@gmail.com>
" Last Change:	2011 dec 11

if exists("b:did_ftplugin")
	finish
endif

let b:did_ftplugin = 1

let s:save_cpo = &cpo
set cpo-=C

setlocal include="^\s*load\>"
setlocal suffixesadd=.jl
setlocal comments=:#
setlocal commentstring=#%s
setlocal cinoptions+=#1
setlocal define="^\s*macro\>"

" Comment the following line if you don't want operators to be
" syntax-highlightened
let g:julia_highlight_operators=1

" Comment the following two lines if you don't want julia source-code
" style being enforced
setlocal shiftwidth=4
setlocal expandtab

if exists("loaded_matchit")
	" note: beginKeywords must contain all blocks in order
	" for nested-structures-skipping to work properly
	let s:beginKeywords = '\<\%(function\|macro\|begin\|type\|let\|do\|module\|quote\|if\|for\|while\|try\)\>'
	let s:endKeyowrds = '\<end\>'

	" note: this function relies heavily on the syntax file
	function! JuliaGetMatchWords()
		let s:attr = synIDattr(synID(line("."),col("."),1),"name")
		"echo s:attr
		if s:attr == 'juliaConditional'
			return s:beginKeywords . ':\<\%(elseif\|else\)\>:' . s:endKeyowrds
		elseif s:attr =~ '\<\%(juliaRepeat\|juliaRepKeyword\)\>'
			return s:beginKeywords . ':\<\%(break\|continue\)\>:' . s:endKeyowrds
		elseif s:attr == 'juliaBlKeyword'
			return s:beginKeywords . ':' . s:endKeyowrds
		elseif s:attr == 'juliaException'
			return s:beginKeywords . ':\<catch\>:' . s:endKeyowrds
		endif
		return ''
	endfunction

	let b:match_words = 'JuliaGetMatchWords()'

	" we need to skip everything within comments, strings and
	" the 'end' keyword when it is used as a range rather than as
	" the end of a block
	let b:match_skip = 'synIDattr(synID(line("."),col("."),1),"name") =~ '
		\ . '"\\<julia\\%(ComprehensionFor\\|RangeEnd\\|QuotedBlockKeyword\\|CommentL\\|\\%(\\|[EILbB]\\|Shell\\)String\\|RegEx\\)\\>"'
endif

if has("gui_win32")
	let b:browsefilter = "Julia Source Files (*.jl)\t*.jl\n"
endif

let b:undo_ftplugin = "setlocal include< suffixesadd< comments< commentstring<"
	\ . " define< shiftwidth< expandtab< indentexpr< indentkeys< cinoptions<"
	\ . " | unlet! b:browsefiler b:match_words b:match_skip"
	\ . " | delfunction JuliaGetMatchWords"

let &cpo = s:save_cpo
unlet s:save_cpo
