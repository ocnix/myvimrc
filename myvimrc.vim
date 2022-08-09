set number
syntax on
set tabstop=8
set expandtab
set softtabstop=4
set shiftwidth=4
filetype indent plugin on

" source the user configuration file(s):
runtime! plugin/<sfile>:t:r.vimrc
" Use the values from the configuration file(s) or the defaults:
let s:min_len = exists("g:WC_min_len") ? g:WC_min_len : 1
let s:accept_key = exists("g:WC_accept_key") ? g:WC_accept_key : "<Tab>"

" Use Vim defaults while :source'ing this file.
let save_cpo = &cpo
set cpo&vim

if has("menu")
  amenu &Tools.&Word\ Completion :call DoWordComplete()<CR>
  amenu &Tools.&Stop\ Completion :call EndWordComplete()<CR>
endif

" Return the :lmap value if there is one, otherwise echo the input.
fun! s:Langmap(char)
  let val = maparg(a:char, "l")
  return (val != "") ? val : a:char
endfun

" The :startinsert command does not have an option for acting like "a"
" instead of "i" so this implements it.
fun! s:StartAppend()
  if strlen(getline(".")) > col(".")
    normal l
    startinsert
  else
    startinsert!
  endif
endfun

fun! WordComplete()
  let length=strlen(expand("<cword>"))
  " Do not try to complete 1- nor 2-character words.
  if length < s:min_len
    call s:StartAppend()
    return
  endif 
  " Save and reset the 'ignorecase' option.
  let save_ic = &ignorecase
  set noignorecase
  " Use language maps (keymaps) if appropriate.
  if &iminsert == 1
    let char = getline(".")[col(".")-1]
    let lchar = maparg(char, "l")
    if lchar != ""
      execute "normal! r" . lchar
    endif
  endif
  " If at EOL or before a space or punctuation character, do completion.
  if strlen(getline(".")) == col(".")
	\ || getline(".")[col(".")] =~ '[[:punct:][:space:]]'
    execute "normal a\<C-P>\<Esc>"
  endif
  " If a match was found, highlight the completed part in Select mode.
  if strlen(expand("<cword>")) > length
    execute "normal viwo" . length . "l\<C-G>"
  else	" ... just return to Insert mode.
    if version > 505
      call s:StartAppend()
    else
      execute "normal a*\<Esc>gh"
    endif "version > 505
  endif
  " Restore the 'ignorecase' option.
  let &ignorecase = save_ic
endfun

" Make an :imap for each alphabetic character, and define a few :smap's.
fun! DoWordComplete()
  execute "snoremap <buffer>" s:accept_key "<Esc>`>a"
  snoremap <buffer> <Esc> d
  if has("mac")
    snoremap <buffer>  <Del>a
  else
    snoremap <buffer> <BS> <Del>a
  endif "has("mac")
  if version > 505
    snoremap <buffer> <C-N> <Del>a<C-N>
    snoremap <buffer> <C-P> <Del>a<C-P><C-P>
    snoremap <buffer> <C-X> <Del>a<C-P><C-X>
  endif "version > 505
  " Thanks to Bohdan Vlasyuk for suggesting a loop here:
  let letter = "a"
  while letter <=# "z"
    execute "inoremap <buffer>" letter letter . "<Esc>:call WordComplete()<CR>"
    let letter = nr2char(char2nr(letter) + 1)
  endwhile
endfun

" Remove all the mappings created by DoWordComplete().
" Lazy:  I do not save and restore existing mappings.
fun! EndWordComplete()
  execute "vunmap <buffer>" s:accept_key
  vunmap <buffer> <Esc>
  if has("mac")
    vunmap <buffer> 
  else
    vunmap <buffer> <BS>
  endif "has("mac")
  if version > 505
    vunmap <buffer> <C-N>
    vunmap <buffer> <C-P>
    vunmap <buffer> <C-X>
  endif "version > 505
  " Thanks to Bohdan Vlasyuk for suggesting a loop here:
  let letter = char2nr("a")
  while letter <= char2nr("z")
    execute "iunmap <buffer>" nr2char(letter)
    let letter = letter + 1
  endwhile
endfun

let &cpo = save_cpo

autocmd BufEnter * call DoWordComplete()


runtime! plugin/<sfile>:t:r.vimrc
" Use the values from the configuration file(s) or the defaults:
let s:min_len = exists("g:WC_min_len") ? g:WC_min_len : 1
let s:accept_key = exists("g:WC_accept_key") ? g:WC_accept_key : "<Tab>"

" Use Vim defaults while :source'ing this file.
let save_cpo = &cpo
set cpo&vim

if has("menu")
  amenu &Tools.&Word\ Completion :call DoWordComplete()<CR>
  amenu &Tools.&Stop\ Completion :call EndWordComplete()<CR>
endif

" Return the :lmap value if there is one, otherwise echo the input.
fun! s:Langmap(char)
  let val = maparg(a:char, "l")
  return (val != "") ? val : a:char
endfun

" The :startinsert command does not have an option for acting like "a"
" instead of "i" so this implements it.
fun! s:StartAppend()
  if strlen(getline(".")) > col(".")
    normal l
    startinsert
  else
    startinsert!
  endif
endfun

fun! WordComplete()
  let length=strlen(expand("<cword>"))
  " Do not try to complete 1- nor 2-character words.
  if length < s:min_len
    call s:StartAppend()
    return
  endif 
  " Save and reset the 'ignorecase' option.
  let save_ic = &ignorecase
  set noignorecase
  " Use language maps (keymaps) if appropriate.
  if &iminsert == 1
    let char = getline(".")[col(".")-1]
    let lchar = maparg(char, "l")
    if lchar != ""
      execute "normal! r" . lchar
    endif
  endif
  " If at EOL or before a space or punctuation character, do completion.
  if strlen(getline(".")) == col(".")
	\ || getline(".")[col(".")] =~ '[[:punct:][:space:]]'
    execute "normal a\<C-P>\<Esc>"
  endif
  " If a match was found, highlight the completed part in Select mode.
  if strlen(expand("<cword>")) > length
    execute "normal viwo" . length . "l\<C-G>"
  else	" ... just return to Insert mode.
    if version > 505
      call s:StartAppend()
    else
      execute "normal a*\<Esc>gh"
    endif "version > 505
  endif
  " Restore the 'ignorecase' option.
  let &ignorecase = save_ic
endfun

" Make an :imap for each alphabetic character, and define a few :smap's.
fun! DoWordComplete()
  execute "snoremap <buffer>" s:accept_key "<Esc>`>a"
  snoremap <buffer> <Esc> d
  if has("mac")
    snoremap <buffer>  <Del>a
  else
    snoremap <buffer> <BS> <Del>a
  endif "has("mac")
  if version > 505
    snoremap <buffer> <C-N> <Del>a<C-N>
    snoremap <buffer> <C-P> <Del>a<C-P><C-P>
    snoremap <buffer> <C-X> <Del>a<C-P><C-X>
  endif "version > 505
  " Thanks to Bohdan Vlasyuk for suggesting a loop here:
  let letter = "a"
  while letter <=# "z"
    execute "inoremap <buffer>" letter letter . "<Esc>:call WordComplete()<CR>"
    let letter = nr2char(char2nr(letter) + 1)
  endwhile
endfun

" Remove all the mappings created by DoWordComplete().
" Lazy:  I do not save and restore existing mappings.
fun! EndWordComplete()
  execute "vunmap <buffer>" s:accept_key
  vunmap <buffer> <Esc>
  if has("mac")
    vunmap <buffer> 
  else
    vunmap <buffer> <BS>
  endif "has("mac")
  if version > 505
    vunmap <buffer> <C-N>
    vunmap <buffer> <C-P>
    vunmap <buffer> <C-X>
  endif "version > 505
  " Thanks to Bohdan Vlasyuk for suggesting a loop here:
  let letter = char2nr("a")
  while letter <= char2nr("z")
    execute "iunmap <buffer>" nr2char(letter)
    let letter = letter + 1
  endwhile
endfun

let &cpo = save_cpo

" vim:sts=2:sw=2:ff=unix:
"
"
:autocmd BufEnter * call DoWordComplete()

" VIM Configuration File
" Description: Optimized for C/C++ development, but useful also for other things.
" Author: Gerhard Gappmeier
"

" set UTF-8 encoding
set enc=utf-8
set fenc=utf-8
set termencoding=utf-8
" disable vi compatibility (emulation of old bugs)
set nocompatible
" use indentation of previous line
set autoindent
" use intelligent indentation for C
set smartindent
" configure tabwidth and insert spaces instead of tabs
set tabstop=4        " tab width is 4 spaces
set shiftwidth=4     " indent also with 4 spaces
set expandtab        " expand tabs to spaces
" wrap lines at 120 chars. 80 is somewaht antiquated with nowadays displays.
set textwidth=120
" turn syntax highlighting on
set t_Co=256
syntax on
" colorscheme wombat256
" turn line numbers on
set number
" highlight matching braces
set showmatch
" intelligent comments
set comments=sl:/*,mb:\ *,elx:\ */

" Install OmniCppComplete like described on http://vim.wikia.com/wiki/C++_code_completion
" This offers intelligent C++ completion when typing ‘.’ ‘->’ or <C-o>
" Load standard tag files
set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/gl
set tags+=~/.vim/tags/sdl
set tags+=~/.vim/tags/qt4

" Install DoxygenToolkit from http://www.vim.org/scripts/script.php?script_id=987
let g:DoxygenToolkit_authorName="John Doe <john@doe.com>"

" Enhanced keyboard mappings
"
" in normal mode F2 will save the file
nmap <F2> :w<CR>
" in insert mode F2 will exit insert, save, enters insert again
imap <F2> <ESC>:w<CR>i
" switch between header/source with F4
map <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
" recreate tags file with F5
map <F5> :!ctags -R –c++-kinds=+p –fields=+iaS –extra=+q .<CR>
" create doxygen comment
map <F6> :Dox<CR>
" build using makeprg with <F7>
map <F7> :make<CR>
" build using makeprg with <S-F7>
map <S-F7> :make clean all<CR>
" goto definition with F12
map <F12> <C-]>
" in diff mode we use the spell check keys for merging
if &diff
  ” diff settings
  map <M-Down> ]c
  map <M-Up> [c
  map <M-Left> do
  map <M-Right> dp
  map <F9> :new<CR>:read !svn diff<CR>:set syntax=diff buftype=nofile<CR>gg
else
  " spell settings
  :setlocal spell spelllang=en
  " set the spellfile - folders must exist
  set spellfile=~/.vim/spellfile.add
  map <M-Down> ]s
  map <M-Up> [s
endif




if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

setlocal iskeyword=a-z,A-Z,48-57,.,_
setlocal isident=a-z,A-Z,48-57,.,_
syn case ignore

syn keyword cTodo		contained TODO FIXME
" a, b r0-7 done with matches
syn keyword mcs51Register	A B R0 R1 R2 R3 R4 R5 R6 R7
syn keyword mcs51Register	P0 SP DPL DPH TCON TMOD TL0 TL1 TH0 TH1 P1 SCON SBUF
syn keyword mcs51Register	P2 IE P3 IP PSW ACC IT0 IE0 IT1 IE1 TR0 TF0 TR1 TF1
syn keyword mcs51Register	RI TI RB8 TB8 REN SM2 SM1 SM0 EX0 ET0 EX1 ET1 ES ET2
syn keyword mcs51Register	EADC EA RXD TXD INT0 INT1 T0 T1 WR RD PX0 PT0 PX1 PT1 PS 
syn keyword mcs51Register	P F1 OV RS0 RS1 F0 AC CY

syn keyword perRegister	DPP PCON I2CDAT I2CADD T3CON T3FD TIMECON HTHSEC SEC MIN HOUR INTVAL DPCON
syn keyword perRegister	IEIP2 PWMCON CFG832 PWM0L PWM0H PWM1L PWM1H SPH ECON EDATA1 EDATA2 EDATA3
syn keyword perRegister	EDATA4 WDCON CHIPID EADRL EADRH T2CON RCAP2L RCAP2H TL2 TH2 DMAL DMAH DMAP
syn keyword perRegister	PLLCON ADCCON2 ADCDATAL ADCDATAH PSMCON DCON I2CCON ADCCON1 ADCOFSL ADCOFSH
syn keyword perRegister	ADCGAINL ADCGAINH ADCCON3 SPIDAT SPICON DAC0L DAC0H DAC1L DAC1H DACCON T2
syn keyword perRegister	T2EX PT2 PADC PSI WDWR WDE WDS WDIR PRE0 PRE1 PRE2 PRE3 CAP2 CNT2 TR2 EXEN2 TCLK
syn keyword perRegister	RCLK EXF2 TF2 CS0 CS1 CS2 CS3 SCONV CCONV DMA ADCI D0EN D0 D1EN D1 I2CI I2CTX
syn keyword perRegister	I2CRS I2CM MDI MCO MDE MDO SPR0 SPR1 CPHA CPOL SPIM SPE WCOL ISPI 

syn keyword mcs51Instr		ADD ADDC SUBB INC DEV MUL DIV MOV MOVC MOVX PUSH POP XCH XCHD
syn keyword mcs51Instr		ACALL LCALL RET RETI AJMP LJMP SJMP JMP JZ JNZ CJNE DJNZ NOP ANL
syn keyword mcs51Instr		ORL XRL CLR CPL RL RLC RR RRC SWAP SETB CPL JC JNC JB JNB JBC 

syn keyword mcs51Directive	DB EQU DATA IDATA XDATA BIT CODE DS DBIT DW ORG END CSEG XSEG DSEG ISEG

syn match	mcs51NumericOperator	"[+-/*]"
" numbers
syn match	mcs51Binary8Number	"\(#[01]\{8\}b\)\|\(\D[01]\{8\}b\)"
syn match	mcs51Binary16Number	"\(#[01]\{16\}b\)\|\(\D[01]\{16\}b\)"
" 00dh should not be recognised as a decimal number!!!
syn match	mcs51DecimalNumber	"\(#0\d*d\)\|\(\D0\d*d[^h]\)"
syn match	mcs51HexNumber		"\(#0\x*h\)\|\(\D0\x*h\)"

syn region	mcs51Comment		start=";" end="$" contains=cTodo
syn region	mcs51String		start="\"" end="\"\|$"
syn region	mcs51String		start="'" end="'\|$"
syn match	mcs51Label		"^[^$]\s*[^; \t]\+:"
syn match	mcs51Preprocess		"^\$\w\+\((.*)\)\?"		
syn match	mcs51Relative		"@R[0-7]\|@a\s*+\s*dptr\|@[ab]"

"syn match	mcs51wreg		"\([\s,]\+[ab][\s,]\+\)\|\([\s,]\+[Rr][0-7][\s,]\+\)"

hi def link	mcs51AddressSizes	type
hi def link	mcs51NumericOperator	mcs51Operator
hi def link	mcs51LogicalOperator	mcs51Operator
hi def link	mcs51Relative		mcs51Operator
hi def link	mcs51Relative1		mcs51Operator

hi def link	mcs51Binary8Number	mcs51Number
hi def link	mcs51Binary16Number	mcs51Number
hi def link	mcs51HexNumber		mcs51Number
hi def link	mcs51DecimalNumber	mcs51Number

hi def link	mcs51Register	type
hi def link	perRegister	type

hi def link	mcs51Preprocess		mcs51Directive
hi def link	mcs51Include		mcs51Directive

"  link to standard syn groups so the 'colorschemes' work:
hi def link	mcs51Operator operator
hi def link	mcs51Comment  comment
hi def link	mcs51Directive	preproc
hi def link	mcs51Number   number
"constant
hi def link	mcs51Symbol structure
hi def link	mcs51String  String
hi def link	mcs51Special 	comment
"special
hi def link	mcs51Instr keyword
hi def link	mcs51Label label
hi def link	mcs51Prefix preproc
hi def link	cTodo todo
hi def link	mcs51wreg identifier
hi def link	mcs51wreg1 identifier
hi def link	mcs51wreg2 identifier
hi def link	mcs51wreg3 identifier
hi def link	mcs51wreg4 identifier

let b:current_syntax = "mcs51a"
" vim: ts=8 sw=8 :


au BufRead,BufNewFile *.asm,*.ASM,*.inc,*.INC,*.lst,*.LST		set filetype=mcs51a


if exists("g:loaded_linuxsty")
    finish
endif
let g:loaded_linuxsty = 1

set wildignore+=*.ko,*.mod.c,*.order,modules.builtin

augroup linuxsty
    autocmd!

    autocmd FileType c,cpp call s:LinuxConfigure()
    autocmd FileType diff,kconfig setlocal tabstop=8
augroup END

function s:LinuxConfigure()
    let apply_style = 0

    if exists("g:linuxsty_patterns")
        let path = expand('%:p')
        for p in g:linuxsty_patterns
            if path =~ p
                let apply_style = 1
                break
            endif
        endfor
    else
        let apply_style = 1
    endif

    if apply_style
        call s:LinuxCodingStyle()
    endif
endfunction

command! LinuxCodingStyle call s:LinuxCodingStyle()

function! s:LinuxCodingStyle()
    call s:LinuxFormatting()
    call s:LinuxKeywords()
    call s:LinuxHighlighting()
endfunction

function s:LinuxFormatting()
    setlocal tabstop=8
    setlocal shiftwidth=8
    setlocal softtabstop=8
    setlocal textwidth=80
    setlocal noexpandtab

    setlocal cindent
    setlocal cinoptions=:0,l1,t0,g0,(0
endfunction

function s:LinuxKeywords()
    syn keyword cOperator likely unlikely
    syn keyword cType u8 u16 u32 u64 s8 s16 s32 s64
    syn keyword cType __u8 __u16 __u32 __u64 __s8 __s16 __s32 __s64
endfunction

function s:LinuxHighlighting()
    highlight default link LinuxError ErrorMsg

    syn match LinuxError / \+\ze\t/     " spaces before tab
    syn match LinuxError /\%81v.\+/     " virtual column 81 and more

    " Highlight trailing whitespace, unless we're in insert mode and the
    " cursor's placed right after the whitespace. This prevents us from having
    " to put up with whitespace being highlighted in the middle of typing
    " something
    autocmd InsertEnter * match LinuxError /\s\+\%#\@<!$/
    autocmd InsertLeave * match LinuxError /\s\+$/
endfunction

" vim: ts=4 et sw=4





























































































