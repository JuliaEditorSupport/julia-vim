" Vim syntax file
" Language:	julia
" Maintainer:	Carlo Baldassi <carlobaldassi@gmail.com>
" Last Change:	2011 dec 11

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syntax cluster juliaExpressions		contains=@juliaParItems,@juliaStringItems,@juliaKeywordItems,@juliaBlocksItems,@juliaTypesItems,@juliaConstItems,@juliaMacroItems,@juliaOperatorItems,@juliaNumberItems,@juliaQuotedItems,@juliaCommentItems,@juliaErrorItems

syntax cluster juliaParItems		contains=juliaParBlock,juliaSqBraBlock,juliaCurBraBlock
syntax cluster juliaKeywordItems	contains=juliaKeyword,juliaTypedef
syntax cluster juliaBlocksItems		contains=juliaConditionalBlock,juliaRepeatBlock,juliaBeginBlock,juliaFunctionBlock,juliaMacroBlock,juliaQuoteBlock,juliaTypeBlock,juliaExceptionBlock,juliaLetBlock,juliaModuleBlock
syntax cluster juliaTypesItems		contains=juliaBuiltinTypeBasic,juliaBuiltinTypeNum,juliaBuiltinTypeError,juliaBuiltinTypeString,juliaBuiltinTypeArray,juliaBuiltinTypeTable,juliaBuiltinTypeSet,juliaBuiltinTypeIO,juliaBuiltinTypeProcess,juliaBuiltinTypeRange,juliaBuiltinTypeRegex,juliaBuiltinTypeSpecial,juliaBuiltinTypeOther
syntax cluster juliaConstItems		contains=juliaConstNum,juliaConstBool,juliaConstIO,juliaConstLimits,juliaConstErrno,juliaConstPcre,juliaConstGeneric
syntax cluster juliaMacroItems		contains=juliaMacro
syntax cluster juliaNumberItems		contains=juliaNumbers
syntax cluster juliaStringItems		contains=juliaChar,juliaString,juliaEString,juliaIString,juliaLString,juliabString,juliafString,juliaShellString,juliaRegEx
syntax cluster juliaOperatorItems	contains=juliaArithOperator,juliaBitOperator,juliaBoolOperator,juliaCompOperator,juliaAssignOperator,juliaRangeOperator,juliaTypeOperator,juliaFuncOperator,juliaCTransOperator,juliaVarargOperator,juliaTernaryRegion
syntax cluster juliaQuotedItems		contains=juliaQuotedBlockKeyword
syntax cluster juliaCommentItems	contains=juliaCommentL
syntax cluster juliaErrorItems		contains=juliaErrorPar,juliaErrorEnd,juliaErrorElse

syntax match   juliaErrorPar		display "[])}]"
syntax match   juliaErrorEnd		display "\<end\>"
syntax match   juliaErrorElse		display "\<\(else\|elseif\)\>"
syntax match   juliaErrorCatch		display "\<catch\>"
syntax match   juliaErrorSemicol	display contained ";"

syntax match   juliaRangeEnd		display contained "\<end\>"

syntax region  juliaParBlock		matchgroup=juliaParDelim start="(" end=")" contains=@juliaExpressions
syntax region  juliaParBlockInRange	matchgroup=juliaParDelim contained start="(" end=")" contains=@juliaExpressions,juliaParBlockInRange,juliaRangeEnd
syntax region  juliaSqBraBlock		matchgroup=juliaParDelim start="\[" end="\]" contains=@juliaExpressions,juliaParBlockInRange,juliaRangeEnd
syntax region  juliaCurBraBlock		matchgroup=juliaParDelim start="{" end="}" contains=@juliaExpressions

syntax match   juliaKeyword		"\<\(return\|local\|break\|continue\|global\|import\|export\|const\)\>"
syntax region  juliaConditionalBlock	matchgroup=juliaConditional start="\<if\>" end="\<end\>" contains=@juliaExpressions,juliaConditionalEIBlock,juliaConditionalEBlock fold
syntax region  juliaConditionalEIBlock	matchgroup=juliaConditional transparent contained start="\<elseif\>" end="\<\(end\|else\|elseif\)\>"me=s-1 contains=@juliaExpressions,juliaConditionalEIBlock,juliaConditionalEBlock
syntax region  juliaConditionalEBlock	matchgroup=juliaConditional transparent contained start="\<else\>" end="\<end\>"me=s-1 contains=@juliaExpressions
syntax region  juliaRepeatBlock		matchgroup=juliaRepeat start="\<\(while\|for\)\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaBeginBlock		matchgroup=juliaKeyword start="\<begin\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaFunctionBlock	matchgroup=juliaKeyword start="\<function\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaMacroBlock		matchgroup=juliaKeyword start="\<macro\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaQuoteBlock		matchgroup=juliaKeyword start="\<quote\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaTypeBlock		matchgroup=juliaKeyword start="\<type\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaExceptionBlock	matchgroup=juliaException start="\<try\>" end="\<end\>" contains=@juliaExpressions,juliaCatchBlock fold
syntax region  juliaCatchBlock		matchgroup=juliaException transparent contained start="\<catch\>" end="\<end\>"me=s-1 contains=@juliaExpressions
syntax region  juliaLetBlock		matchgroup=juliaKeyword start="\<let\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaModuleBlock		matchgroup=juliaKeyword start="\<module\>" end="\<end\>" contains=@juliaExpressions fold
syntax match   juliaTypedef		"\<\(abstract\|typealias\|bitstype\)\>"

syntax match   juliaBuiltinTypeBasic	display "\<\(Tuple\|NTuple\|Symbol\|Function\|Union\|Type\(\|Name\|Constructor\|Var\)\|Any\|None\|Nothing\|Ptr\|Void\|Exception\|Module\|Box\|Expr\|LambdaStaticData\|\(Abstract\|Composite\|Bits\|Func\|Union\)Kind\|\(LineNumber\|Label\|Goto\|Quote\|Top\|Symbol\)Node\|WeakRef\|Associative\|Long\(Symbol\|Tuple\|Expr\)\)\>"
syntax match   juliaBuiltinTypeNum	display "\<\(Uint\(\|8\|16\|32\|64\)\|Int\(\|8\|16\|32\|64\)\|Float\(\|32\|64\)\|Complex\(\|64\|128\|Pair\)\|Bool\|Char\|Number\|Real\|Integer\|Rational\|BigInt\|\)\>"
syntax match   juliaBuiltinTypeError	display "\<\(\(Bounds\|DivideByZero\|Memory\|IO\|StackOverflow\|EOF\|UndefRef\|System\|Type\|Parse\|Argument\|Unbound\|Key\|Load\|Method\)Error\|\(Interrupt\|Error\|MatrixIllConditioned\|Disconnect\)Exception\|BackTrace\)\>"
syntax match   juliaBuiltinTypeString	display "\<\(\(\|DirectIndex\|ASCII\|UTF\(8\|32\)\|Byte\|Sub\|Latin1\|Generic\|Char\|Rep\|Rev\|Rope\|Transformed\)String\)\>"
syntax match   juliaBuiltinTypeArray	display "\<\(Array\|DArray\|Abstract\(Array\|Vector\|Matrix\)\|Strided\(Array\|Vector\|Matrix\|VecOrMat\)\|VecOrMat\|Sparse\(MatrixCSC\|Accumulator\)\|Vector\|Matrix\|Sub\(Array\|DArray\|OrDArray\)\)\>"
syntax match   juliaBuiltinTypeTable	display "\<\(\(\(\|WeakKey\)Hash\|Var\|Id\)Table\)\>"
syntax match   juliaBuiltinTypeSet	display "\<\(\(\|Int\)Set\)\>"
syntax match   juliaBuiltinTypeIO	display "\<\(IOStream\|IOTally\|FDSet\|LineIterator\)\>"
syntax match   juliaBuiltinTypeProcess	display "\<\(Process\(Status\|NotRun\|Running\|Exited\|Signaled\|Stopped\)\|FileDes\|Pipe\(\|In\|Out\|End\)\|Executable\|Cmds\?\|Ports\?\)\>"
syntax match   juliaBuiltinTypeRange	display "\<\(Dims\|Range\(\|s\|1\|Index\)\|Indices\|Region\)\>"
syntax match   juliaBuiltinTypeRegex	display "\<\(Regex\(\|Match\(\|Iterator\)\)\)\>"
syntax match   juliaBuiltinTypeSpecial	display "\<\(NotFound\|EmptyCallStack\|LocalProcess\|EnvHash\|ImaginaryUnit\)\>"
syntax match   juliaBuiltinTypeOther	display "\<\(UniqueNames\|CallStack\|StaticVarInfo\|StateUpdate\|ShivaIterator\|Worker\|Location\|ProcessGroup\|RemoteRef\|GORef\|WorkItem\|WaitFor\|GlobalObject\|VersionNumber\)\>"

syntax match   juliaConstNum		display "\<\(pi\|e\|NaN\(32\)\?\|Inf\(32\)\?\)\>"
syntax match   juliaConstBool		display "\<\(true\|false\)\>"
syntax match   juliaConstIO		display "\<\(std\(out\|in\|err\)_stream\|STD\(OUT\|IN\|ERR\)\|sizeof_\(ios_t\|fd_set\)\|ENV\)\>"
syntax match   juliaConstPtr		display "\<\(WORD_SIZE\|C_NULL\)\>"
syntax match   juliaConstLimits		display "\<\(MAX_\(TYPEUNION_\(LEN\|DEPTH\)\|TUPLE\(_DEPTH\|TYPE_LEN\)\)\|GRISU_\(SHORTEST\(\|_SINGLE\)\|FIXED\|PRECISION\)\)\>"
syntax match   juliaConstErrno		display "\<E\(2BIG\|ACCES\|ADDRINUSE\|ADDRNOTAVAIL\|ADV\|AFNOSUPPORT\|AGAIN\|ALREADY\|BADE\|BADFD\|BADF\|BADMSG\|BADR\|BADRQC\|BADSLT\|BFONT\|BUSY\|CANCELED\|CHILD\|CHRNG\|COMM\|CONNABORTED\|CONNREFUSED\|CONNRESET\|DEADLK\|DESTADDRREQ\|DOM\|DOTDOT\|DQUOT\|EXIST\|FAULT\|FBIG\|HOSTDOWN\|HOSTUNREACH\|HWPOISON\|IDRM\|ILSEQ\|INPROGRESS\|INTR\|INVAL\|IO\|ISCONN\|ISDIR\|ISNAM\|KEYEXPIRED\|KEYREJECTED\|KEYREVOKED\|L2HLT\|L2NSYNC\|L3HLT\|L3RST\|LIBACC\|LIBBAD\|LIBEXEC\|LIBMAX\|LIBSCN\|LNRNG\|LOOP\|MEDIUMTYPE\|MFILE\|MLINK\|MSGSIZE\|MULTIHOP\|NAMETOOLONG\|NAVAIL\|NETDOWN\|NETRESET\|NETUNREACH\|NFILE\|NOANO\|NOBUFS\|NOCSI\|NODATA\|NODEV\|NOENT\|NOEXEC\|NOKEY\|NOLCK\|NOLINK\|NOMEDIUM\|NOMEM\|NOMSG\|NONET\|NOPKG\|NOPROTOOPT\|NOSPC\|NOSR\|NOSTR\|NOSYS\|NOTBLK\|NOTCONN\|NOTDIR\|NOTEMPTY\|NOTNAM\|NOTRECOVERABLE\|NOTSOCK\|NOTTY\|NOTUNIQ\|NXIO\|OPNOTSUPP\|OVERFLOW\|OWNERDEAD\|PERM\|PFNOSUPPORT\|PIPE\|PROTO\|PROTONOSUPPORT\|PROTOTYPE\|RANGE\|REMCHG\|REMOTE\|REMOTEIO\|RESTART\|RFKILL\|ROFS\|SHUTDOWN\|SOCKTNOSUPPORT\|SPIPE\|SRCH\|SRMNT\|STALE\|STRPIPE\|TIMEDOUT\|TIME\|TOOMANYREFS\|TXTBSY\|UCLEAN\|UNATCH\|USERS\|XDEV\|XFULL\)\>"
syntax match   juliaConstPcre		display "\<PCRE_\(ANCHORED\|AUTO_CALLOUT\|BSR_ANYCRLF\|BSR_UNICODE\|CASELESS\|CONFIG_BSR\|CONFIG_JIT\|CONFIG_LINK_SIZE\|CONFIG_MATCH_LIMIT\|CONFIG_MATCH_LIMIT_RECURSION\|CONFIG_NEWLINE\|CONFIG_POSIX_MALLOC_THRESHOLD\|CONFIG_STACKRECURSE\|CONFIG_UNICODE_PROPERTIES\|CONFIG_UTF8\|DFA_RESTART\|DFA_SHORTEST\|DOLLAR_ENDONLY\|DOTALL\|DUPNAMES\|ERROR_BADCOUNT\|ERROR_BADMAGIC\|ERROR_BADNEWLINE\|ERROR_BADOFFSET\|ERROR_BADOPTION\|ERROR_BADPARTIAL\|ERROR_BADUTF8\|ERROR_BADUTF8_OFFSET\|ERROR_CALLOUT\|ERROR_DFA_RECURSE\|ERROR_DFA_UCOND\|ERROR_DFA_UITEM\|ERROR_DFA_UMLIMIT\|ERROR_DFA_WSSIZE\|ERROR_INTERNAL\|ERROR_JIT_STACKLIMIT\|ERROR_MATCHLIMIT\|ERROR_NOMATCH\|ERROR_NOMEMORY\|ERROR_NOSUBSTRING\|ERROR_NULL\|ERROR_NULLWSLIMIT\|ERROR_PARTIAL\|ERROR_RECURSELOOP\|ERROR_RECURSIONLIMIT\|ERROR_SHORTUTF8\|ERROR_UNKNOWN_NODE\|ERROR_UNKNOWN_OPCODE\|EXTENDED\|EXTRA\|EXTRA_CALLOUT_DATA\|EXTRA_EXECUTABLE_JIT\|EXTRA_MARK\|EXTRA_MATCH_LIMIT\|EXTRA_MATCH_LIMIT_RECURSION\|EXTRA_STUDY_DATA\|EXTRA_TABLES\|FIRSTLINE\|INFO_BACKREFMAX\|INFO_CAPTURECOUNT\|INFO_DEFAULT_TABLES\|INFO_FIRSTBYTE\|INFO_FIRSTCHAR\|INFO_FIRSTTABLE\|INFO_HASCRORLF\|INFO_JCHANGED\|INFO_JIT\|INFO_JITSIZE\|INFO_LASTLITERAL\|INFO_MINLENGTH\|INFO_NAMECOUNT\|INFO_NAMEENTRYSIZE\|INFO_NAMETABLE\|INFO_OKPARTIAL\|INFO_OPTIONS\|INFO_SIZE\|INFO_STUDYSIZE\|JAVASCRIPT_COMPAT\|MAJOR\|MINOR\|MULTILINE\|NEWLINE_ANY\|NEWLINE_ANYCRLF\|NEWLINE_CR\|NEWLINE_CRLF\|NEWLINE_LF\|NO_AUTO_CAPTURE\|NO_START_OPTIMISE\|NO_START_OPTIMIZE\|NOTBOL\|NOTEMPTY\|NOTEMPTY_ATSTART\|NOTEOL\|NO_UTF8_CHECK\|PARTIAL\|PARTIAL_HARD\|PARTIAL_SOFT\|STUDY_JIT_COMPILE\|UCP\|UNGREEDY\|UTF8\|UTF8_ERR0\|UTF8_ERR1\|UTF8_ERR10\|UTF8_ERR11\|UTF8_ERR12\|UTF8_ERR13\|UTF8_ERR14\|UTF8_ERR15\|UTF8_ERR16\|UTF8_ERR17\|UTF8_ERR18\|UTF8_ERR19\|UTF8_ERR2\|UTF8_ERR20\|UTF8_ERR21\|UTF8_ERR3\|UTF8_ERR4\|UTF8_ERR5\|UTF8_ERR6\|UTF8_ERR7\|UTF8_ERR8\|UTF8_ERR9\|\(COMPILE\|EXECUTE\|OPTIONS\)_MASK\)\>"
syntax match   juliaConstGeneric	display "\<\(nothing\|NF\)\>"

syntax match   juliaMacro		display "@[_[:alpha:]][_[:alnum:]]*"

syntax match   juliaNumbers		display transparent "\<\d\|\.\d\|\<im\>" contains=juliaNumber,juliaFloat,juliaComplexUnit

syntax match   juliaNumber		display contained "\d\+\(\>\|im\>\|\ze[_[:alpha:]]\)" contains=juliaComplexUnit
"hex number
syntax match   juliaNumber		display contained "0x\x\+\(\>\|im\>\|\ze[_[:alpha:]]\)" contains=juliaComplexUnit
"floating point number, with dot, optional exponent
syntax match   juliaFloat		display contained "\d\+\.\d*\([eE][-+]\?\d\+\)\?\(\>\|im\>\|\ze[_[:alpha:]]\)" contains=juliaComplexUnit
"floating point number, starting with a dot, optional exponent
syntax match   juliaFloat		display contained "\.\d\+\([eE][-+]\?\d\+\)\?\(\>\|im\>\|\ze[_[:alpha:]]\)" contains=juliaComplexUnit
"floating point number, without dot, with exponent
syntax match   juliaFloat		display contained "\d\+[eE][-+]\?\d\+\(\>\|im\>\|\ze[_[:alpha:]]\)" contains=juliaComplexUnit

syntax match   juliaComplexUnit		display	contained "\<im\>"

syntax match   juliaArithOperator	"\(+\|-\|//\|%\|\.\?\(*\|/\|\\\|\^\)\)"
syntax match   juliaCompOperator	"[<>]"
syntax match   juliaBitOperator		"\(<<\|>>>\|>>\|\\&\||\|\~\)"
syntax match   juliaBoolOperator	"\(\\&\\&\|||\|!\)"
syntax match   juliaCompOperator	"\([<>]=\|!=\|==\)"
syntax match   juliaAssignOperator	"\([|\&*/\\%+-]\|<<\|>>>\|>>\)\?="
syntax match   juliaRangeOperator	":"
syntax match   juliaTypeOperator	"\(<:\|::\)"
syntax match   juliaFuncOperator	"->"
syntax match   juliaVarargOperator	"\.\{3\}"
syntax match   juliaCTransOperator	"'"
syntax region  juliaTernaryRegion	matchgroup=juliaTernaryOperator start="?" skip="::" end=":" contains=@juliaExpressions,juliaErrorSemicol

syntax match   juliaChar		display "'\\\?.'" contains=juliaSpecialChar
syntax match   juliaChar		display "'\\\o\{3\}'" contains=juliaOctalEscapeChar
syntax match   juliaChar		display "'\\x\x\{2\}'" contains=juliaHexEscapeChar
syntax match   juliaChar		display "'\\u\x\{1,4\}'" contains=juliaUniCharSmall
syntax match   juliaChar		display "'\\U\x\{1,8\}'" contains=juliaUniCharLarge

syntax region  juliaString		matchgroup=juliaStringDelim start=+"+ skip=+\(\\\\\)*\\"+ end=+"+ contains=@juliaStringVars,@juliaSpecialChars
syntax region  juliaEString		matchgroup=juliaStringDelim start=+E"+ skip=+\(\\\\\)*\\"+ end=+"+ contains=@juliaSpecialChars
syntax region  juliaIString		matchgroup=juliaStringDelim start=+I"+ skip=+\(\\\\\)*\\"+ end=+"+ contains=@juliaStringVars
syntax region  juliaLString		matchgroup=juliaStringDelim start=+L"+ skip=+\(\\\\\)*\\"+ end=+"+
syntax region  juliabString		matchgroup=juliaStringDelim start=+b"+ skip=+\(\\\\\)*\\"+ end=+"+ contains=@juliaSpecialChars
syntax region  juliafString		matchgroup=juliaStringDelim start=+f"+ skip=+\(\\\\\)*\\"+ end=+"+ contains=@juliaSpecialChars,@juliaPrintfChars

syntax region  juliaShellString		matchgroup=juliaStringDelim start=+`+ skip=+\(\\\\\)*\\`+ end=+`+ contains=@juliaStringVars,juliaSpecialChar

syntax cluster juliaStringVars		contains=juliaStringVarsPar,juliaStringVarsSqBra,juliaStringVarsCurBra,juliaStringVarsPla
syntax region  juliaStringVarsPar	contained matchgroup=juliaStringVarDelim start="$(" end=")" contains=@juliaExpressions
syntax region  juliaStringVarsSqBra	contained matchgroup=juliaStringVarDelim start="$\[" end="\]" contains=@juliaExpressions
syntax region  juliaStringVarsCurBra	contained matchgroup=juliaStringVarDelim start="${" end="}" contains=@juliaExpressions
syntax match   juliaStringVarsPla	contained "$[_[:alpha:]][_[:alnum:]]*"

" TODO improve RegEx
syntax region  juliaRegEx		matchgroup=juliaStringDelim start=+ri\?m\?s\?"+ skip=+\(\\\\\)*\\"+ end=+"+

syntax cluster juliaSpecialChars	contains=juliaSpecialChar,juliaOctalEscapeChar,juliaHexEscapeChar,juliaUniCharSmall,juliaUniCharLarge
syntax match   juliaSpecialChar		contained "\\."
syntax match   juliaOctalEscapeChar	contained "\\\o\{3\}"
syntax match   juliaHexEscapeChar	contained "\\x\x\{2\}"
syntax match   juliaUniCharSmall	contained "\\u\x\{1,4\}"
syntax match   juliaUniCharLarge	contained "\\U\x\{1,8\}"

syntax cluster juliaPrintfChars		contains=juliaErrorPrintfFmt,juliaPrintfFmt
syntax match   juliaErrorPrintfFmt	display contained "\\\?%."
syntax match   juliaPrintfFmt		display contained "%\(\d\+\$\)\=[-+' #0]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlLjqzt]\|ll\|hh\)\=[aAbdiuoxXDOUfFeEgGcCsSpn]"
syntax match   juliaPrintfFmt		display contained "%%"
syntax match   juliaPrintfFmt		display contained "\\%\(\d\+\$\)\=[-+' #0]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([hlLjqzt]\|ll\|hh\)\=[aAbdiuoxXDOUfFeEgGcCsSpn]"hs=s+1
syntax match   juliaPrintfFmt		display contained "\\%%"hs=s+1

syntax match   juliaQuotedBlockKeyword	display ":\s*\(if\|elseif\|else\|while\|for\|begin\|function\|macro\|quote\|type\|try\|catch\|let\|module\)"he=s+1

syntax region  juliaCommentL		matchgroup=juliaCommentDelim start="#" end="$" keepend contains=@juliaCommentSpace
syntax cluster juliaCommentSpace	contains=juliaTodo
syntax keyword juliaTodo		contained TODO FIXME XXX


hi def link juliaParDelim		juliaNone

hi def link juliaKeyword		Keyword
hi def link juliaConditional		Conditional
hi def link juliaRepeat			Repeat
hi def link juliaException		Exception
hi def link juliaTypedef		Typedef
hi def link juliaBuiltinTypeBasic	Type
hi def link juliaBuiltinTypeNum		Type
hi def link juliaBuiltinTypeError	Type
hi def link juliaBuiltinTypeString	Type
hi def link juliaBuiltinTypeArray	Type
hi def link juliaBuiltinTypeTable	Type
hi def link juliaBuiltinTypeSet		Type
hi def link juliaBuiltinTypeIO		Type
hi def link juliaBuiltinTypeProcess	Type
hi def link juliaBuiltinTypeRange	Type
hi def link juliaBuiltinTypeRegex	Type
hi def link juliaBuiltinTypeSpecial	Type
hi def link juliaBuiltinTypeOther	Type
hi def link juliaConstNum		Constant
hi def link juliaConstIO		Constant
hi def link juliaConstPtr		Constant
hi def link juliaConstLimits		Constant
hi def link juliaConstErrno		Constant
hi def link juliaConstPcre		Constant
hi def link juliaConstGeneric		Constant
hi def link juliaConstBool		Boolean
hi def link juliaRangeEnd		Constant

hi def link juliaMacro			Macro

hi def link juliaNumber			Number
hi def link juliaFloat			Float
hi def link juliaComplexUnit		Constant

hi def link juliaChar			Character

hi def link juliaString			String
hi def link juliaEString		String
hi def link juliaIString		String
hi def link juliaLString		String
hi def link juliabString		String
hi def link juliafString		String
hi def link juliaShellString		String
hi def link juliaStringDelim		String
hi def link juliaStringVarsPla		Identifier
hi def link juliaStringVarDelim		Delimiter

hi def link juliaRegEx			String

hi def link juliaSpecialChar		SpecialChar
hi def link juliaOctalEscapeChar	SpecialChar
hi def link juliaHexEscapeChar		SpecialChar
hi def link juliaUniCharSmall		SpecialChar
hi def link juliaUniCharLarge		SpecialChar

hi def link juliaPrintfFmt		SpecialChar

if exists("g:julia_highlight_operators")
  hi def link juliaOperator		Operator
else
  hi def link juliaOperator		juliaNone
endif
hi def link juliaArithOperator		juliaOperator
hi def link juliaBitOperator		juliaOperator
hi def link juliaBoolOperator		juliaOperator
hi def link juliaCompOperator		juliaOperator
hi def link juliaAssignOperator		juliaOperator
hi def link juliaRangeOperator		juliaOperator
hi def link juliaTypeOperator		juliaOperator
hi def link juliaFuncOperator		juliaOperator
hi def link juliaCTransOperator		juliaOperator
hi def link juliaVarargOperator		juliaOperator
hi def link juliaTernaryOperator	juliaOperator

hi def link juliaQuotedBlockKeyword	juliaOperator

hi def link juliaCommentL		Comment
hi def link juliaCommentDelim		Comment
hi def link juliaTodo			Todo

hi def link juliaErrorPar		juliaError
hi def link juliaErrorEnd		juliaError
hi def link juliaErrorElse		juliaError
hi def link juliaErrorCatch		juliaError
hi def link juliaErrorSemicol		juliaError
hi def link juliaErrorPrintfFmt		juliaError

hi def link juliaError			Error

if exists("julia_minlines")
  let b:julia_minlines = julia_minlines
else
  let b:julia_minlines = 50
endif

syn sync fromstart
" exec "syn sync match juliaSyncBlock grouphere juliaParBlock /(/"

let b:current_syntax = "julia"
