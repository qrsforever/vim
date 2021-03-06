"{{{ Setup
"个人的openkey, 可以自己申请
let g:api_key = "356090979"
let g:keyfrom = "lovezyt"

"lidong 个人添加, 不依赖网络， 翻译托福4500多个单词
let g:trv_grep = "grep"       "搜索的命令
let g:trv_grepOptions = "-i"    "Grep命令参数忽略大小写
let g:trv_dictionary = expand(g:VIM_HOME . '/dict/toefl_eng.txt')  "Grep搜索单词的文件 toefl_eng.txt: 托福4000多个单词

func ListDictWords(A, L, P) "{{{
    return system('cat ' . g:trv_dictionary . ' | cut -d\  -f1')
endfunc "}}}

func! s:GetTransLoc()  "{{{
    let word = expand("<cword>")
    if word == ""
        let word = input("Input: ", "" , "custom,ListDictWords")
        redraw
    endif
    if word == ""
        return 0
    endif
    let cmd = g:trv_grep . " " . g:trv_grepOptions . " " . "\"\\\<" . word  . "\\\>\"" . " " . g:trv_dictionary
    let len0 = len(word)
    let result = system(cmd)
    if result == ""
        exec 'Dict ' . word
    else
        let len1 = len(result)
        echomsg word " ==> " . result[len0+1:len1-2]
    endif
endfunc "}}}

"}}}

nmap <unique> <silent> <leader>tr :call <SID>GetTransLoc()<CR>
nmap <unique> <silent> <leader>td <Plug>DictSearch
nmap <unique> <silent> <leader>tw <Plug>DictWSearch
vmap <unique> <silent> <leader>tw <Plug>DictWVSearch
nmap <unique> <silent> <leader>tR <Plug>DictRSearch
vmap <unique> <silent> <leader>tR <Plug>DictRVSearch
