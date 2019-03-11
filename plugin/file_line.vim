" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_file_line') || (v:version < 700)
	finish
endif
let g:loaded_file_line = 1

function! s:gotoline()
	let file = bufname("%")

	" :e command calls BufRead even though the file is a new one.
	" As a workarround Jonas Pfenniger<jonas@pfenniger.name> added an
	" AutoCmd BufRead, this will test if this file actually exists before
	" searching for a file and line to goto.
	if (filereadable(file))
		return
	endif

	" Accept file:line:column: or file:line:column and file:line also
	" let names =  matchlist( file, '\(.\{-1,}\):\%(\(\d\+\)\%(:\(\d*\):\?\)\?\)\?$')
    " ld change accept file:line:xxx or file:line.xxx
	let names =  matchlist( file, '\(.\{-1,}\):\%(\(\d\+\)\%([:\.]\([A-Za-z0-9_]*\):\?\)\?\)\?$')
    " ld end

	if empty(names)
		return
	endif

	let file_name = names[1]
    let line_num  = names[2] == ''? '0' : names[2]
	" let  col_num  = names[3] == ''? '0' : names[3]
    " ld change 
    let  col_num  = '0'
    if names[3] != ''
        let col_names =  matchlist( names[3], '\(\d*\)')
        let col_num   = col_names[0] == ''? '0' : col_names[0]
    endif
    " ld end

	if filereadable(file_name)
		let l:bufn = bufnr("%")
        " lidong change 
        exec ":bwipeout! " l:bufn
        " lidong end
        " exec ":bwipeout " l:bufn
        exec "keepalt edit " . file_name
 		exec ":" . line_num
        exec "normal! " . col_num . '|'
        if foldlevel(line_num) > 0
            exec "normal! zv"
        endif
        exec "normal! zz"
	endif

endfunction

autocmd! BufNewFile *:* nested call s:gotoline()
autocmd! BufRead *:* nested call s:gotoline()
