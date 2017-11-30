" neocomplete Setup {{{

" Note: This option must set it in .vimrc(_vimrc).
" NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1

" Set minimum syntax keyword length.
let g:neocomplete#min_keyword_length = 3
let g:neocomplete#sources#buffer#disabled_pattern = '\.log\|\.log\.\|\.jax'
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*|\.log\|\.log\.\|.*quickrun.*\|.jax'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
            \ 'xml' : "~/.vim/dict/android_xml.txt,~/.vim/dict/ant_xml.txt",
            \ 'text' : '~/.vim/dict/wordlist.txt'
            \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" <CR>: close popup and save indent."{{{
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
    return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
    " For no inserting <CR> key.
    "return pumvisible() ? "\<C-y>" : "\<CR>"
    "
    " 回车总是有问题, 暂时的处理方式
    " if pumvisible() 
    "     call neocomplete#close_popup()
    "     return "\<Space>"
    " else
    "     return "\<CR>"
    " endif
endfunction
"}}}

" <TAB>: completion."{{{
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ neocomplete#start_manual_complete()

function! s:check_back_space() abort 
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction
"}}}

" Or set this.
let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

let g:neocomplete#cursor_hold_i_time = 1000

let g:neocomplete#force_overwrite_completefunc=1 
let g:neocomplete#sources#buffer#cache_limit_size = 1000000
let g:neocomplete#sources#tags#cache_limit_size   = 30000000

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
if has('python3')
    autocmd FileType python setlocal omnifunc=python3complete#Complete
else
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
endif
    

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif

" let g:neocomplete#sources#omni#input_patterns.java = '\k\.\k*'
" let g:neocomplete#sources#omni#input_patterns.ruby = ''
let g:neocomplete#sources#omni#input_patterns.python = '[^. *\t]\.\w*\|\h\w*'

"let g:neocomplete#sources#omni#input_patterns.php =
"           \ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
"
" omnicppcomte插件已包含
" let g:neocomplete#sources#omni#input_patterns.c =
"            \ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
" let g:neocomplete#sources#omni#input_patterns.cpp =
"             \ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
endif

" let g:neocomplete#sources#omni#input_patterns.php =   
            \ '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?' 

" 必须要有这个否则<c-x><c-o>不会自动弹出 
" let g:neocomplete#force_omni_input_patterns.java = '\k\.\k*'
" fix eclim does't work
let g:neocomplete#force_omni_input_patterns.java = '\%(\h\w*\|)\)\.\w*'
" jedi
let g:neocomplete#force_omni_input_patterns.python =
            \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'

" }}}
