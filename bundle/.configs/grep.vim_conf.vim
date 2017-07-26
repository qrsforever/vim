" 将光标位置放到所要搜索的字符串上, 按F7, 默认搜索所有(*)类型文件
"fgrep : 将正则表达式的符号当作字符搜索 eg. $ [a|b]
"
let Grep_Default_Options = '-iI'
let Grep_Skip_Dirs = '.svn .bak tag .git RCS CVS SCCS'
let Grep_Skip_Files = '*.bak *~ *.obj *.o *.bin *.elf tags'
let Grep_OpenQuickfixWindow = 1
let Grep_Null_Device = '/dev/null'
let Grep_Shell_Quote_Char = "'"
let Grep_Default_Filelist = '*'

command! -nargs=* -complete=file MyGrep call s:DoSelectGrep(<f-args>)

let s:MRUGrepWordsFile = expand('$HOME/.MRUGrepWordsFile')
let s:MaxCount = 30

func ListCandidateWord(A, L, P)
    return system("cat " . s:MRUGrepWordsFile)
endfunc

func! s:InputWords()
    if ! filereadable(s:MRUGrepWordsFile)
        call writefile([], s:MRUGrepWordsFile)
    endif
    let grepwords = readfile(s:MRUGrepWordsFile)

    echohl Search
    let tmpstr = input("Search for pattern: ", expand("<cword>"), 'custom,ListCandidateWord')
    echohl None
    if len(tmpstr) < 2
        unlet grepwords
        return ""
    endif
    let outputs = []
    let addflg = 1
    for line in grepwords
        if line == tmpstr
            let addflg = 0
        endif
    endfor 
    if addflg == 1
        call add(outputs, tmpstr)
        let cnt = 1
        for line in grepwords
            if cnt < s:MaxCount
                call add(outputs, line)
            endif
            let cnt += 1
        endfor
        call writefile(outputs, s:MRUGrepWordsFile)
        unlet outputs
    endif
    return tmpstr
    " let twd = split(tmpstr, '|')
    " let len = len(twd)
    " let words=''
    " let i = 0
    " while i < len
    "     if i == 0
    "         let words = twd[i]
    "     else
    "         let words = words . '\|' . twd[i]
    "     endif
    "     let i = i + 1
    " endwhile
    " return words
endfunc

func! s:DoSelectGrep() 
    echomsg ' Use Shift+F2 Shift+F3 (for next match pattern)'
    echomsg ' 1. lvimgrep(current file)'
    echomsg ' 2. egrep(current file)'
    echomsg ' 3. fegrep(current file)'
    echomsg ' 4. rgrep(dir)'
    echomsg ' 5. bgrep(buffer)' 
    echomsg ' 6. cscope'
    echohl Search
    let select = str2nr(input("Select Search Method: ", ' '), 10)         
    echohl None

    " exec "Mark " 
    let word = s:InputWords()
    exec "lchdir %:p:h"
    exec "cclose"
    if select == 1
        exec "silent! lvimgrep '" . word . "' " . expand('%')
        exec "belowright lw 15"
    elseif select == 2
        exec "Egrep '" . word . "' " . expand('%')
    elseif select == 3
        exec "Fgrep '" . word . "' " . expand('%')
    elseif select == 4
        exec "Regrep '" . word . "'"
    elseif select == 5
        exec "Bgrep '" . word . "'"
    elseif select == 6
        exec "cs find e '" . word . "'"
        exec "belowright cw 15"
    else
        return
    endif
    " exec "Mark " . word 
    exec "redraw"
endfunc
