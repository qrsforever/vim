"{{{ Base
let g:jupyter_runflags = '-i'
let g:jupyter_auto_connect = 0
let g:jupyter_verbose = 0
let g:jupyter_mapkeys = 1
let g:jupyter_monitor_console = 1
let g:jupyter_vsplit = 1
let g:jupyter_mapkeys = 0

let g:priv_window_mode = 'v'

function! s:DoCommandDelayUpdate(cmd)
    try
        exec a:cmd
    catch
        echomsg "jupyter import this file error!"
        return
    endtry
    " 等待notebook kernel return data
    call system("sleep 0.5")
    if g:priv_window_mode == 'v'
        exec 'silent! JupyterUpdateVShell'
    else
        exec 'silent! JupyterUpdateShell'
    endif
    " not working
    " let bufid = winbufnr('__jupyter_term__')
    " if bufid != -1
        " exec bufid . 'windo norm zz'
    " endif
endfunction

" 终端窗口
function! s:DoUpdateWindow(flag)
    if bufexists('__jupyter_term__')
        if a:flag == 1 || a:flag == 3
            exec 'bwipeout __jupyter_term__'
            return
        elseif a:flag == 0
            exec 'bwipeout __jupyter_term__'
        elseif a:flag == 2
            let bufid = bufnr('__jupyter_term__')
            if bufid != -1
                exec 'bunload! ' . bufid
            endif
        endif
    endif
    if a:flag == 1
        return
    endif
    if g:priv_window_mode == 'v'
        exec 'silent! JupyterUpdateVShell'
    else
        exec 'silent! JupyterUpdateShell'
    endif
endfunction

function! s:DoCommand(flag)
    let var = expand("<cword>")
    if a:flag == "t"
        exec 'JupyterSendCode ' . '"print(type(' . var . '))"'
    elseif a:flag == "f"
        exec 'JupyterSendCode ' . '"!eog /tmp/jupyter_vim.png"'
    elseif a:flag == "p"
        exec 'JupyterSendCode ' . '"print(' . var . ')"'
    elseif a:flag == "v"
        if g:priv_window_mode != 'v'
            let g:priv_window_mode = 'v'
            call <SID>DoUpdateWindow(0)
        endif
    elseif a:flag == "h"
        if g:priv_window_mode != 'h'
            let g:priv_window_mode = 'h'
            call <SID>DoUpdateWindow(0)
        endif
    elseif a:flag == "1"
        exec 'JupyterSendCode ' . '"' . var . '.head(1)"'
    elseif a:flag == "2"
        exec 'JupyterSendCode ' . '"' . var . '.head(2)"'
    elseif a:flag == "3"
        exec 'JupyterSendCode ' . '"' . var . '.head(3)"'
    elseif a:flag == "4"
        exec 'JupyterSendCode ' . '"' . var . '.head(4)"'
    elseif a:flag == "5"
        exec 'JupyterSendCode ' . '"' . var . '.head(5)"'
    elseif a:flag == "6"
        exec 'JupyterSendCode ' . '"' . var . '.tail(1)"'
    elseif a:flag == "7"
        exec 'JupyterSendCode ' . '"' . var . '.tail(2)"'
    elseif a:flag == "8"
        exec 'JupyterSendCode ' . '"' . var . '.tail(3)"'
    elseif a:flag == "9"
        exec 'JupyterSendCode ' . '"' . var . '.tail(4)"'
    elseif a:flag == "0"
        exec 'JupyterSendCode ' . '"' . var . '.tail(5)"'
    endif
endfunction

function! s:DoCreateAndConnect()
    exec 'silent! !~/.vim/bin/0jupyter-qtconsole.sh'
    echomsg "wait start..."
    call system("sleep 4.5")
    exec 'redraw!'
    exec 'JupyterConnect'
endfunction

command Jupyter      call <SID>DoCreateAndConnect()
"}}}

nnoremap <unique> <silent> <leader>ji :call <SID>DoCommandDelayUpdate("PythonImportThisFile")<CR>
nnoremap <unique> <silent> <leader>jj :call <SID>DoCommandDelayUpdate("JupyterSendCount")<CR>
nnoremap <unique> <silent> <leader>jb :PythonSetBreak<CR>
" clear window, 窗口数据太多, 需要清理(主动)
nnoremap <unique> <silent> <leader>jc :call <SID>DoUpdateWindow(0)<CR>
" update window, 有时数据量, 回调数据慢, 需要更新(被动)
nnoremap <unique> <silent> <leader>ju :call <SID>DoUpdateWindow(2)<CR>
nnoremap <unique> <silent> <leader>jq :call <SID>DoUpdateWindow(1)<CR>
nnoremap <unique> <silent> <leader>jw :call <SID>DoUpdateWindow(3)<CR>

nnoremap <unique> <silent> <leader>jC :JupyterConnect<CR>

" 将映射集中到左右字符('q,w,e,r,s,d')
nnoremap <unique> <silent> <leader>jr :call <SID>DoCommandDelayUpdate("JupyterRunFile")<CR>
nnoremap <unique> <silent> <leader>jd :call <SID>DoCommandDelayUpdate("JupyterCd %:p:h")<CR>
nnoremap <unique> <silent> <leader>je :call <SID>DoCommandDelayUpdate("JupyterSendCell")<CR>
nmap     <unique> <silent> <leader>js <Plug>JupyterRunTextObj
vmap     <unique> <silent> <leader>js <Plug>JupyterRunVisual

nnoremap <unique> <silent> <leader>jt :call <SID>DoCommand("t")<CR>
nnoremap <unique> <silent> <leader>jp :call <SID>DoCommand("p")<CR>
nnoremap <unique> <silent> <leader>jf :call <SID>DoCommand("f")<CR>
nnoremap <unique> <silent> <leader>jh :call <SID>DoCommand("h")<CR>
nnoremap <unique> <silent> <leader>jv :call <SID>DoCommand("v")<CR>

nnoremap <unique> <silent> <leader>j1 :call <SID>DoCommand("1")<CR>
nnoremap <unique> <silent> <leader>j2 :call <SID>DoCommand("2")<CR>
nnoremap <unique> <silent> <leader>j3 :call <SID>DoCommand("3")<CR>
nnoremap <unique> <silent> <leader>j4 :call <SID>DoCommand("4")<CR>
nnoremap <unique> <silent> <leader>j5 :call <SID>DoCommand("5")<CR>
nnoremap <unique> <silent> <leader>j6 :call <SID>DoCommand("6")<CR>
nnoremap <unique> <silent> <leader>j7 :call <SID>DoCommand("7")<CR>
nnoremap <unique> <silent> <leader>j8 :call <SID>DoCommand("8")<CR>
nnoremap <unique> <silent> <leader>j9 :call <SID>DoCommand("9")<CR>
nnoremap <unique> <silent> <leader>j0 :call <SID>DoCommand("0")<CR>


augroup JupyterTerm
    au BufEnter __jupyter_term__ silent! nmap <silent> <buffer> q :silent! q<CR>
    au BufEnter __jupyter_term__ setlocal wrap
augroup END
