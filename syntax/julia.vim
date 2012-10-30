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
syntax cluster juliaExprsPrintf		contains=@juliaExpressions,@juliaPrintfItems

syntax cluster juliaParItems		contains=juliaParBlock,juliaSqBraBlock,juliaCurBraBlock
syntax cluster juliaKeywordItems	contains=juliaKeyword,juliaRepKeyword,juliaTypedef
syntax cluster juliaBlocksItems		contains=juliaConditionalBlock,juliaRepeatBlock,juliaBeginBlock,juliaFunctionBlock,juliaMacroBlock,juliaQuoteBlock,juliaTypeBlock,juliaExceptionBlock,juliaLetBlock,juliaDoBlock,juliaModuleBlock
syntax cluster juliaTypesItems		contains=juliaBuiltinTypeBasic,juliaBuiltinTypeNum,juliaBuiltinTypeError,juliaBuiltinTypeIter,juliaBuiltinTypeString,juliaBuiltinTypeArray,juliaBuiltinTypeDict,juliaBuiltinTypeSet,juliaBuiltinTypeIO,juliaBuiltinTypeProcess,juliaBuiltinTypeRange,juliaBuiltinTypeRegex,juliaBuiltinTypeOptions,juliaBuitinTypeFact,juliaBuiltinTypeSpecial,juliaBuiltinTypeOther
syntax cluster juliaConstItems		contains=juliaConstNum,juliaConstBool,juliaConstEnv,juliaConstIO,juliaConstMMap,juliaConstPtr,juliaConstErrno,juliaConstMulti,juliaConstGeneric
syntax cluster juliaMacroItems		contains=juliaMacro,juliaDollarVar,juliaPrintfMacro
syntax cluster juliaNumberItems		contains=juliaNumbers
syntax cluster juliaStringItems		contains=juliaChar,juliaString,juliaEString,juliaIString,juliaLString,juliabString,juliaShellString,juliaRegEx
syntax cluster juliaPrintfItems		contains=juliaPrintfParBlock,juliaPrintfString
syntax cluster juliaOperatorItems	contains=juliaArithOperator,juliaBitOperator,juliaBoolOperator,juliaCompOperator,juliaAssignOperator,juliaRangeOperator,juliaTypeOperator,juliaFuncOperator,juliaCTransOperator,juliaVarargOperator,juliaTernaryRegion
syntax cluster juliaQuotedItems		contains=juliaQuotedBlockKeyword
syntax cluster juliaCommentItems	contains=juliaCommentL
syntax cluster juliaErrorItems		contains=juliaErrorPar,juliaErrorEnd,juliaErrorElse

syntax match   juliaErrorPar		display "[])}]"
syntax match   juliaErrorEnd		display "\<end\>"
syntax match   juliaErrorElse		display "\<\%(else\|elseif\)\>"
syntax match   juliaErrorCatch		display "\<catch\>"
syntax match   juliaErrorSemicol	display contained ";"

syntax match   juliaRangeEnd		display contained "\<end\>"

syntax region  juliaParBlock		matchgroup=juliaParDelim start="(" end=")" contains=@juliaExpressions
syntax region  juliaParBlockInRange	matchgroup=juliaParDelim contained start="(" end=")" contains=@juliaExpressions,juliaParBlockInRange,juliaRangeEnd
syntax region  juliaSqBraBlock		matchgroup=juliaParDelim start="\[" end="\]" contains=@juliaExpressions,juliaParBlockInRange,juliaRangeEnd,juliaComprehensionFor
syntax region  juliaCurBraBlock		matchgroup=juliaParDelim start="{" end="}" contains=@juliaExpressions,juliaComprehensionFor

syntax match   juliaKeyword		"\<\%(return\|local\|global\|import\|export\|const\|in\)\>"
syntax match   juliaRepKeyword		"\<\%(break\|continue\)\>"
syntax region  juliaConditionalBlock	matchgroup=juliaConditional start="\<if\>" end="\<end\>" contains=@juliaExpressions,juliaConditionalEIBlock,juliaConditionalEBlock fold
syntax region  juliaConditionalEIBlock	matchgroup=juliaConditional transparent contained start="\<elseif\>" end="\<\%(end\|else\|elseif\)\>"me=s-1 contains=@juliaExpressions,juliaConditionalEIBlock,juliaConditionalEBlock
syntax region  juliaConditionalEBlock	matchgroup=juliaConditional transparent contained start="\<else\>" end="\<end\>"me=s-1 contains=@juliaExpressions
syntax region  juliaRepeatBlock		matchgroup=juliaRepeat start="\<\%(while\|for\)\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaBeginBlock		matchgroup=juliaBlKeyword start="\<begin\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaFunctionBlock	matchgroup=juliaBlKeyword start="\<function\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaMacroBlock		matchgroup=juliaBlKeyword start="\<macro\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaQuoteBlock		matchgroup=juliaBlKeyword start="\<quote\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaTypeBlock		matchgroup=juliaBlKeyword start="\<type\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaLetBlock		matchgroup=juliaBlKeyword start="\<let\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaDoBlock		matchgroup=juliaBlKeyword start="\<do\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaModuleBlock		matchgroup=juliaBlKeyword start="\<module\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaExceptionBlock	matchgroup=juliaException start="\<try\>" end="\<end\>" contains=@juliaExpressions,juliaCatchBlock fold
syntax region  juliaCatchBlock		matchgroup=juliaException transparent contained start="\<catch\>" end="\<end\>"me=s-1 contains=@juliaExpressions
syntax match   juliaTypedef		"\<\%(abstract\|typealias\|bitstype\)\>"

syntax match   juliaComprehensionFor    display contained "\<for\>"

syntax match   juliaBuiltinTypeBasic	display "\<\%(Tuple\|NTuple\|Symbol\|\%(Intrinsic\)\?Function\|Union\|Type\%(Name\|Constructor\|Error\|Var\)\?\|Any\|Top\|None\|Nothing\|Ptr\|Void\|Undef\|Exception\|Module\|Box\|Expr\|LambdaStaticData\|\%(Abstract\|Composite\|Bits\|Union\)Kind\|\%(LineNumber\|Label\|Goto\|Quote\|Top\|Symbol\|Getfield\)Node\|WeakRef\|Associative\|Method\(Table\)\?\|Long\(Symbol\|Tuple\|Expr\)\)\>"
syntax match   juliaBuiltinTypeNum	display "\<\%(Uint\%(\|8\|16\|32\|64\|128\)\|Int\%(eger\|8\|16\|32\|64\|128\)\?\|Float\%(ingPoint\|32\|64\)\|Complex\%(64\|128\|Pair\)\?\|Bool\|Chars\?\|Number\|Signed\|Unsigned\|Real\|Rational\|BigInt\|FileOffset\)\>"
syntax match   juliaBuiltinTypeError	display "\<\%(\%(Bounds\|DivideByZero\|Domain\|Memory\|IO\|\%(Stack\)\?Overflow\|EOF\|UndefRef\|System\|Type\|Parse\|Argument\|Key\|Load\|Method\|Inexact\)Error\|\%(Interrupt\|Error\|Disconnect\)Exception\|BackTrace\)\>"
syntax match   juliaBuiltinTypeIter	display "\<\%(Each\%(Line\|Search\)\|Enumerate\|Filter\)\>"
syntax match   juliaBuiltinTypeString	display "\<\%(DirectIndex\|ASCII\|UTF8\|Byte\|Sub\|Generic\|Char\|Rep\|Rev\|Rope\|Transformed\)\?String\>"
syntax match   juliaBuiltinTypeArray	display "\<\%(Array\|DArray\|Abstract\%(Array\|Vector\|Matrix\)\|Strided\%(Array\|Vector\|Matrix\|VecOrMat\)\|VecOrMat\|Sparse\%(MatrixCSC\|Accumulator\)\|Vector\|Matrix\|Sub\%(Array\|DArray\|OrDArray\)\|Bit\%(Array\|Vector\|Matrix\)\|Tridiagonal\)\>"
syntax match   juliaBuiltinTypeDict	display "\<\%(WeakKey\|ObjectId\)\?Dict\>"
syntax match   juliaBuiltinTypeSet	display "\<\%(Int\)\?Set\>"
syntax match   juliaBuiltinTypeIO	display "\<\%(IO\(Stream\)\?\|FDSet\|Stat\)\>"
syntax match   juliaBuiltinTypeProcess	display "\<\%(Process\%(Status\|NotRun\|Running\|Exited\|Signaled\|Stopped\)\|FileDes\|Pipe\%(In\|Out\|End\)\?\|Executable\|Cmds\?\|Ports\?\)\>"
syntax match   juliaBuiltinTypeRange	display "\<\%(Dims\(pec\)\?\|Range\%(s\|1\|Index\)\?\|Indices\|Colon\|Reverse\|Zip\)\>"
syntax match   juliaBuiltinTypeRegex	display "\<Regex\%(Match\%(Iterator\)\?\)\?\>"
syntax match   juliaBuiltinTypeOptions	display "\<\%(Options\|Check\%(Warn\|None\|Error\)\)\>"
syntax match   juliaBuiltinTypeFact	display "\<\%(Factorization\|Cholesky\|LU\|QRP\?\)\>"
syntax match   juliaBuiltinTypeSpecial	display "\<\%(LocalProcess\|EnvHash\|ImaginaryUnit\)\>"
syntax match   juliaBuiltinTypeOther	display "\<\%(Location\|ProcessGroup\|RemoteRef\|Task\|GlobalObject\|VersionNumber\)\>"

syntax match   juliaConstNum		display "\<\%(pi\|e\|NaN\%(32\)\?\|Inf\%(32\)\?\)\>"
syntax match   juliaConstBool		display "\<\%(true\|false\)\>"
syntax match   juliaConstEnv		display "\<\%(ARGS\|ENV\|CPU_CORES\|OS_NAME\|ENDIAN_BOM\|LOAD_PATH\|RANDOM_SEED\|VERSION\)\>"
syntax match   juliaConstIO		display "\<\%(std\%(out\|in\|err\)_stream\|STD\%(OUT\|IN\|ERR\)\|OUTPUT_STREAM\)\>"
syntax match   juliaConstMMap		display "\<\%(MS_\%(A\?SYNC\|INVALIDATE\)\)\>"
syntax match   juliaConstPtr		display "\<\%(WORD_SIZE\|C_NULL\)\>"
syntax match   juliaConstErrno		display "\<E\%(A\%(CCES\|LREADY\|D\%(DR\%(INUSE\|NOTAVAIL\)\|V\)\|GAIN\|FNOSUPPORT\)\|C\%(ANCELED\|H\%(ILD\|RNG\)\|O\%(MM\|NN\%(ABORTED\|RE\%(SET\|FUSED\)\)\)\)\|B\%(AD\%(MSG\|SLT\|R\%(\|QC\)\|E\|F\%(\|D\)\)\|USY\|FONT\)\|EXIST\|D\%(QUOT\|E\%(ADLK\|STADDRREQ\)\|O\%(M\|TDOT\)\)\|F\%(AULT\|BIG\)\|I\%(S\%(CONN\|DIR\|NAM\)\|N\%(PROGRESS\|TR\|VAL\)\|DRM\|O\|LSEQ\)\|H\%(WPOISON\|OST\%(UNREACH\|DOWN\)\)\|KEY\%(RE\%(JECTED\|VOKED\)\|EXPIRED\)\|M\%(ULTIHOP\|SGSIZE\|EDIUMTYPE\|LINK\|FILE\)\|L\%(IB\%(ACC\|MAX\|SCN\|BAD\|EXEC\)\|3\%(HLT\|RST\)\|2\%(HLT\|NSYNC\)\|OOP\|NRNG\)\|O\%(PNOTSUPP\|WNERDEAD\|VERFLOW\)\|N\%(A\%(METOOLONG\|VAIL\)\|XIO\|ET\%(RESET\|UNREACH\|DOWN\)\|O\%(ANO\|CSI\|BUFS\|E\%(XEC\|NT\)\|D\%(ATA\|EV\)\|KEY\|M\%(SG\|E\%(M\|DIUM\)\)\|L\%(INK\|CK\)\|NET\|P\%(KG\|ROTOOPT\)\|S\%(YS\|PC\|R\|TR\)\|T\%(CONN\|BLK\|EMPTY\|DIR\|NAM\|SOCK\|RECOVERABLE\|UNIQ\|TY\)\)\|FILE\)\|P\%(IPE\|ROTO\%(\|TYPE\|NOSUPPORT\)\|ERM\|FNOSUPPORT\)\|S\%(HUTDOWN\|R\%(CH\|MNT\)\|T\%(ALE\|RPIPE\)\|OCKTNOSUPPORT\|PIPE\)\|2BIG\|U\%(CLEAN\|SERS\|NATCH\)\|T\%(IME\%(\|DOUT\)\|XTBSY\|OOMANYREFS\)\|X\%(DEV\|FULL\)\|R\%(ANGE\|E\%(START\|M\%(CHG\|OTE\%(\|IO\)\)\)\|OFS\|FKILL\)\)\>"
syntax match   juliaConstMulti		display "\<Scheduler\>"
syntax match   juliaConstGeneric	display "\<nothing\>"

syntax match   juliaMacro		display "@[_[:alpha:]][_[:alnum:]!]*\%(\.[_[:alpha:]][_[:alnum:]!]*\)*"

syntax match   juliaNumbers		display transparent "\<\d\|\.\d\|\<im\>" contains=juliaNumber,juliaFloat,juliaComplexUnit

"decimal number
syntax match   juliaNumber		display contained "\d\%(_\?\d\)*\%(\>\|im\>\|\ze[_[:alpha:]]\)" contains=juliaComplexUnit
"hex number
syntax match   juliaNumber		display contained "0x\x\%(_\?\x\)*\%(\>\|im\>\|\ze[_[:alpha:]]\)" contains=juliaComplexUnit
"bin number
syntax match   juliaNumber		display contained "0b[01]\%(_\?[01]\)*\%(\>\|im\>\|\ze[_[:alpha:]]\)" contains=juliaComplexUnit
"oct number
syntax match   juliaNumber		display contained "0o\o\%(_\?\o\)*\%(\>\|im\>\|\ze[_[:alpha:]]\)" contains=juliaComplexUnit
"floating point number, ending with a dot, optional exponent
"syntax match   juliaFloat		display contained "\d\%(_\?\d\)*\.\%([eE][-+]\?\d\+\>\)\?\%(im\>\|\ze[_[:alpha:]]\)\?" contains=juliaComplexUnit
"floating point number, starting with a dot, optional exponent
syntax match   juliaFloat		display contained "\.\d\%(_\?\d\)*\%([eE][-+]\?\d\+\)\?\%(\>\|im\>\|\ze[_[:alpha:]]\)" contains=juliaComplexUnit
"floating point number, with dot, optional exponent
syntax match   juliaFloat		display contained "\d\%(_\?\d\)*\.\%(\d\%(_\?\d\)*\)\?\%([eE][-+]\?\d\+\)\?\%(\>\|im\>\|\ze[_[:alpha:]]\)" contains=juliaComplexUnit
"floating point number, without dot, with exponent
syntax match   juliaFloat		display contained "\d\%(_\?\d\)*[eE][-+]\?\d\+\%(\>\|im\>\|\ze[_[:alpha:]]\)" contains=juliaComplexUnit

syntax match   juliaComplexUnit		display	contained "\<im\>"

syntax match   juliaArithOperator	"\%(+\|-\|//\|%\|\.\?\%(\*\|/\|\\\|\^\)\)"
syntax match   juliaCompOperator	"\.\?[<>]"
syntax match   juliaBitOperator		"\%(<<\|>>>\|>>\|&\||\|\~\|\$\)"
syntax match   juliaBoolOperator	"\%(&&\|||\|!\)"
syntax match   juliaCompOperator	"\.\?\%([<>]=\|!=\|==\)"
syntax match   juliaAssignOperator	"\%([$|\&*/\\%+-]\|<<\|>>>\|>>\)\?="
syntax match   juliaRangeOperator	":"
syntax match   juliaTypeOperator	"\%(<:\|::\)"
syntax match   juliaFuncOperator	"->"
syntax match   juliaVarargOperator	"\.\{3\}"
syntax match   juliaCTransOperator	"\.\?'"
syntax region  juliaTernaryRegion	matchgroup=juliaTernaryOperator start="?" skip="::" end=":" contains=@juliaExpressions,juliaErrorSemicol

" TODO: this is very greedy. Improve?
syntax match   juliaDollarVar		contained "[[:alnum:]_]\@<!$[_[:alpha:]][_[:alnum:]!]*"

syntax match   juliaChar		display "'\\\?.'" contains=juliaSpecialChar
syntax match   juliaChar		display "'\\\o\{3\}'" contains=juliaOctalEscapeChar
syntax match   juliaChar		display "'\\x\x\{2\}'" contains=juliaHexEscapeChar
syntax match   juliaChar		display "'\\u\x\{1,4\}'" contains=juliaUniCharSmall
syntax match   juliaChar		display "'\\U\x\{1,8\}'" contains=juliaUniCharLarge

syntax region  juliaString		matchgroup=juliaStringDelim start=+S\?"+ skip=+\%(\\\\\)*\\"+ end=+"+ contains=@juliaStringVars,@juliaSpecialChars
syntax region  juliaEString		matchgroup=juliaStringDelim start=+E"+ skip=+\%(\\\\\)*\\"+ end=+"+ contains=@juliaSpecialChars
syntax region  juliaIString		matchgroup=juliaStringDelim start=+I"+ skip=+\%(\\\\\)*\\"+ end=+"+ contains=@juliaStringVars
syntax region  juliaLString		matchgroup=juliaStringDelim start=+L"+ skip=+\%(\\\\\)*\\"+ end=+"+
syntax region  juliabString		matchgroup=juliaStringDelim start=+[bB]"+ skip=+\%(\\\\\)*\\"+ end=+"+ contains=@juliaSpecialChars

syntax region  juliaPrintfMacro		transparent start="@s\?printf(" end=")\@<=" contains=juliaMacro,juliaPrintfParBlock
syntax region  juliaPrintfMacro		transparent start="@s\?printf\s\+" end="\n" contains=@juliaExprsPrintf
syntax region  juliaPrintfParBlock	contained matchgroup=juliaParDelim start="(" end=")" contains=@juliaExprsPrintf
syntax region  juliaPrintfString	contained matchgroup=juliaStringDelim start=+"+ skip=+\%(\\\\\)*\\"+ end=+"+ contains=@juliaSpecialChars,@juliaPrintfChars

syntax region  juliaShellString		matchgroup=juliaStringDelim start=+`+ skip=+\%(\\\\\)*\\`+ end=+`+ contains=@juliaStringVars,juliaSpecialChar

syntax cluster juliaStringVars		contains=juliaStringVarsPar,juliaStringVarsSqBra,juliaStringVarsCurBra,juliaStringVarsPla
syntax region  juliaStringVarsPar	contained matchgroup=juliaStringVarDelim start="$(" end=")" contains=@juliaExpressions
syntax region  juliaStringVarsSqBra	contained matchgroup=juliaStringVarDelim start="$\[" end="\]" contains=@juliaExpressions
syntax region  juliaStringVarsCurBra	contained matchgroup=juliaStringVarDelim start="${" end="}" contains=@juliaExpressions
syntax match   juliaStringVarsPla	contained "$[_[:alpha:]][_[:alnum:]]*"

" TODO improve RegEx
syntax region  juliaRegEx		matchgroup=juliaStringDelim start=+r"+ skip=+\%(\\\\\)*\\"+ end=+"[imsx]*+

syntax cluster juliaSpecialChars	contains=juliaSpecialChar,juliaOctalEscapeChar,juliaHexEscapeChar,juliaUniCharSmall,juliaUniCharLarge
syntax match   juliaSpecialChar		contained "\\."
syntax match   juliaOctalEscapeChar	contained "\\\o\{3\}"
syntax match   juliaHexEscapeChar	contained "\\x\x\{2\}"
syntax match   juliaUniCharSmall	contained "\\u\x\{1,4\}"
syntax match   juliaUniCharLarge	contained "\\U\x\{1,8\}"

syntax cluster juliaPrintfChars		contains=juliaErrorPrintfFmt,juliaPrintfFmt
syntax match   juliaErrorPrintfFmt	display contained "\\\?%."
syntax match   juliaPrintfFmt		display contained "%\%(\d\+\$\)\=[-+' #0]*\%(\d*\|\*\|\*\d\+\$\)\%(\.\%(\d*\|\*\|\*\d\+\$\)\)\=\%([hlLjqzt]\|ll\|hh\)\=[aAbdiuoxXDOUfFeEgGcCsSpn]"
syntax match   juliaPrintfFmt		display contained "%%"
syntax match   juliaPrintfFmt		display contained "\\%\%(\d\+\$\)\=[-+' #0]*\%(\d*\|\*\|\*\d\+\$\)\%(\.\%(\d*\|\*\|\*\d\+\$\)\)\=\%([hlLjqzt]\|ll\|hh\)\=[aAbdiuoxXDOUfFeEgGcCsSpn]"hs=s+1
syntax match   juliaPrintfFmt		display contained "\\%%"hs=s+1

syntax match   juliaQuotedBlockKeyword	display ":\s*\%(if\|elseif\|else\|while\|for\|begin\|function\|macro\|quote\|type\|try\|catch\|let\|module\|do\)\>"

syntax region  juliaCommentL		matchgroup=juliaCommentDelim start="#" end="$" keepend contains=@juliaCommentSpace
syntax cluster juliaCommentSpace	contains=juliaTodo
syntax keyword juliaTodo		contained TODO FIXME XXX


hi def link juliaParDelim		juliaNone

hi def link juliaKeyword		Keyword
hi def link juliaRepKeyword		Keyword
hi def link juliaBlKeyword		Keyword
hi def link juliaConditional		Conditional
hi def link juliaRepeat			Repeat
hi def link juliaException		Exception
hi def link juliaTypedef		Typedef
hi def link juliaBuiltinTypeBasic	Type
hi def link juliaBuiltinTypeNum		Type
hi def link juliaBuiltinTypeError	Type
hi def link juliaBuiltinTypeIter	Type
hi def link juliaBuiltinTypeString	Type
hi def link juliaBuiltinTypeArray	Type
hi def link juliaBuiltinTypeDict	Type
hi def link juliaBuiltinTypeSet		Type
hi def link juliaBuiltinTypeIO		Type
hi def link juliaBuiltinTypeProcess	Type
hi def link juliaBuiltinTypeRange	Type
hi def link juliaBuiltinTypeRegex	Type
hi def link juliaBuiltinTypeOptions	Type
hi def link juliaBuiltinTypeFact	Type
hi def link juliaBuiltinTypeSpecial	Type
hi def link juliaBuiltinTypeOther	Type
hi def link juliaConstNum		Constant
hi def link juliaConstEnv		Constant
hi def link juliaConstIO		Constant
hi def link juliaConstMMap		Constant
hi def link juliaConstPtr		Constant
hi def link juliaConstLimits		Constant
hi def link juliaConstErrno		Constant
hi def link juliaConstMulti		Constant
hi def link juliaConstGeneric		Constant
hi def link juliaRangeEnd		Constant
hi def link juliaConstBool		Boolean

hi def link juliaComprehensionFor	Keyword

hi def link juliaDollarVar		Identifier

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
hi def link juliaPrintfString		String
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

syntax sync fromstart

let b:current_syntax = "julia"
