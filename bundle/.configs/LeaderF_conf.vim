"{{{ Setup

let g:Lf_ShortcutF = '<leader>f'
let g:Lf_ShortcutB = '<leader>b'
" let g:Lf_WindowPosition = 'bottom'
let g:Lf_WindowHeight = '0.5'
let g:Lf_TabpagePosition = 0
let g:Lf_ShowRelativePath = 0
let g:Lf_CursorBlink = 1
let g:Lf_DefaultMode = 'NameOnly'
let g:Lf_MruFileExclude = ['*.so', '*.class', '*.o']
let g:Lf_MruMaxFiles = 120
let g:Lf_DefaultExternalTool = 'rg'
let g:Lf_UseCache = 1
let g:Lf_StlColorscheme = 'powerline'

let g:Lf_Ctags = 'ctags'
let g:Lf_CtagsFuncOpts = {
    \ 'c': '-I __THROW --c++-kinds=+p --c-kinds=fp --fields=+ialS --extras=+q',
    \ 'rust': '--rust-kinds=f',
\ }

let g:Lf_RgConfig = [
    \ "--max-columns=250",
    \ "--case-sensitive",
\ ]

let g:Lf_WildIgnore = {
    \ 'dir': ['.svn','.git','.hg'],
    \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.class','*.so','*.py[co]']
\ }

let g:Lf_PreviewResult = {
    \ 'File': 0,
    \ 'Buffer': 0,
    \ 'Mru': 0,
    \ 'Tag': 0,
    \ 'BufTag': 1,
    \ 'Function': 0,
    \ 'Line': 0,
    \ 'Colorscheme': 0
\}

let g:Lf_RootMarkers = ['.project', '.svn', '.git', '.hg', '.gradle']
let g:Lf_HideHelp = 1

let g:Lf_CommandMap = {
    \ '<C-X>': ['<C-S>'],
    \ '<C-]>': ['<C-V>'],
    \ '<C-J>': ['<C-J>', '<C-N>'],
    \ '<C-K>': ['<C-K>', '<C-P>'],
\}

"    <C-C>, <ESC> : quit from LeaderF.
"    <C-R> : switch between fuzzy search mode and regex mode.
"    <C-F> : switch between full path search mode and name only search mode.
"    <Tab> : switch to normal mode.
"    <C-V>, <S-Insert> : paste from clipboard.
"    <C-U> : clear the prompt.
"    <C-J>, <C-K> : navigate the result list.
"    <Up>, <Down> : recall last/next input pattern from history.
"    <2-LeftMouse> or <CR> : open the file under cursor or selected(when
"                            multiple files are selected).
"    <C-X> : open in horizontal split window.
"    <C-]> : open in vertical split window.
"    <C-T> : open in new tabpage.
"    <F5>  : refresh the cache.
"    <C-LeftMouse> or <C-S> : select multiple files.
"    <S-LeftMouse> : select consecutive multiple files.
"    <C-A> : select all files.
"    <C-L> : clear all selections.
"    <BS>  : delete the preceding character in the prompt.
"    <Del> : delete the current character in the prompt.
"    <Home>: move the cursor to the begin of the prompt.
"    <End> : move the cursor to the end of the prompt.
"    <Left>: move the cursor one character to the left.
"    <Right> : move the cursor one character to the right.
"    <C-P> : preview the result.

function! s:DoLeaderfFileWithPath()
    let dirstr = input("Searching from: ", getcwd(), "dir")
    if dirstr == ""
        return
    endif
    exec 'LeaderfFile ' . dirstr
endfunc
command! -bar -nargs=0 MyLeaderfFile call s:DoLeaderfFileWithPath()

function! s:DoBufExplorer()
    exec 'normal \<esc>'
    exec 'normal sb'
endfunc
command! MyBufExplorer call s:DoBufExplorer()

" usage: Leaderf[!] [-h] [--reverse] [--stayOpen] [--input <INPUT> | --cword]
" [--top | --bottom | --left | --right | --belowright | --aboveleft | --fullScreen]
" [--nameOnly | --fullPath | --fuzzy | --regexMode] [--nowrap]
" {file,tag,function,mru,searchHistory,cmdHistory,help,line,colorscheme,self,bufTag,buffer,rg}

" Warning conflict with unite.vim or fuzzyfinder
nnoremap <unique> <silent> [search]b :<C-U>Leaderf! --fullScreen --nameOnly --nowrap buffer<CR>
nnoremap <unique> <silent> [search]c :<C-U>Leaderf! cmdHistory<CR>

" 搜索[当前目录]中的文件
nnoremap <unique> <silent> [search]f :<C-U>LeaderfFile<CR>
nnoremap <unique> <silent> [search]F :<C-U>MyLeaderfFile<CR>

" 搜索[当前字符]最近文件
nnoremap <unique> <silent> [search]n :<C-U>Leaderf! mru<CR>
nnoremap <unique> <silent> [search]N :<C-U>Leaderf! --cword mru<CR>

" 查找[所有]buffer中某个函数名或变量
nnoremap <unique> <silent> [search], :<C-U>Leaderf! --cword bufTag<CR>
nnoremap <unique> <silent> [search]< :<C-U>Leaderf! bufTag<CR>

" 查找[所有]buffer中的某个函数
nnoremap <unique> <silent> [search]. :<C-U>Leaderf! --cword function --all<CR>
nnoremap <unique> <silent> [search]> :<C-U>Leaderf! function --all<CR>

" 从Tag文件中查找某个函数或变量名 (], }留给YCM使用
nnoremap <unique> <silent> [search][ :<C-U>Leaderf! --cword --nowrap tag<CR>
nnoremap <unique> <silent> [search]{ :<C-U>Leaderf! --nowrap tag<CR>

" 搜索字符串
nnoremap <unique> <silent> [search]/ :<C-U><C-R>=printf("Leaderf! --nowrap rg --current-buffer -e %s ", expand("<cword>"))<CR><CR>
nnoremap <unique> <silent> [search]g :<C-U><C-R>=printf("Leaderf! --nowrap rg -e %s ", expand("<cword>"))<CR><CR>
nnoremap <unique> <silent> [search]+ :<C-U><C-R>=printf("Leaderf! --nowrap rg --append -e %s ", expand("<cword>"))<CR><CR>
nnoremap <unique> <silent> [search]w :<C-U>Leaderf! rg --stayOpen --recall<CR><CR>

"}}}