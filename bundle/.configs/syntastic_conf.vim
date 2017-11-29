" Syntastic Setup {{{
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" let g:syntastic_aggregate_errors = 1
let g:syntastic_enable_signs = 1
let g:syntastic_echo_current_error = 1
let g:syntastic_enable_balloons = 1
let g:syntastic_enable_highlighting = 0
let g:syntastic_loc_list_height = 10
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = '☢'
let g:syntastic_style_error_symbol = '✍'
let g:syntastic_style_warning_symbol = '✍'
let g:syntastic_auto_loc_list = 2
let g:syntastic_show_warnings = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_rust_checkers = ['rustc']
let g:syntastic_mode_map = { "mode": "active", "passive_filetypes": ["go", "html"] }
let g:syntastic_python_checkers=['python', 'pyflakes']
let g:syntastic_python_python_exec = '/usr/bin/python3'
let g:syntastic_python_pyflakes_exe = 'python3 -m pyflakes'
" let g:syntastic_python_flake8_args='--ignore=E501'
"
" let g:syntastic_quiet_messages = { "level": "warnings" }
" let g:syntastic_python_pylint_quiet_messages = { "level" : [] }

" from https://github.com/oblitum/dotfiles/blob/2166c92b76892b8f9c4124dbba6675f2e95053da/.vimrc#L498-L514
" gets background of a highlighting group with fallback to SignColumn group
function! s:getbg(group)
    if has('gui_running') || has('termguicolors') && &termguicolors
        let l:mode = 'gui'
        let l:validation = '\w\+\|#\x\+'
    else
        let l:mode = 'cterm'
        let l:validation = '\w\+'
    endif

    if synIDattr(synIDtrans(hlID(a:group)), 'reverse', l:mode)
        let l:bg = synIDattr(synIDtrans(hlID(a:group)), 'fg', l:mode)
    else
        let l:bg = synIDattr(synIDtrans(hlID(a:group)), 'bg', l:mode)
    endif

    if l:bg == '-1' || l:bg !~ l:validation
        if synIDattr(synIDtrans(hlID('SignColumn')), 'reverse', l:mode)
            let l:bg = synIDattr(synIDtrans(hlID('SignColumn')), 'fg', l:mode)
        else
            let l:bg = synIDattr(synIDtrans(hlID('SignColumn')), 'bg', l:mode)
        endif
    endif

    if l:bg == '-1' || l:bg !~ l:validation
        let l:bg = 'NONE'
    endif

    return l:mode . 'bg=' . l:bg
endfunction
" hi! link SyntasticErrorLine   SignColumn
" hi! link SyntasticWarningLine SignColumn
au VimEnter,ColorScheme * exec 'hi! SyntasticErrorSign   guifg=red ctermfg=red ' .       s:getbg('SyntasticErrorLine')
au VimEnter,ColorScheme * exec 'hi! SyntasticWarningSign guifg=yellow ctermfg=yellow ' . s:getbg('SyntasticWarningLine')
au VimEnter,ColorScheme * exec 'hi! SyntasticError ' .   s:getbg('SyntasticErrorLine')
au VimEnter,ColorScheme * exec 'hi! SyntasticWarning ' . s:getbg('SyntasticWarningLine')

" }}}
