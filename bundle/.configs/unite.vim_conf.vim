"{{{ Setup
" Enable history yank source
let g:unite_source_history_yank_enable = 0
let g:unite_enable_split_vertically = 0

let g:unite_source_file_rec_max_cache_files = 0
let g:unite_source_rec_max_cache_files = 0
let g:unite_source_rec_min_cache_files = 120
let g:unite_source_buffer_time_format = "(%Y-%m-%d %H:%M:%S) "
let g:unite_force_overwrite_statusline = 0
let g:unite_ignore_source_files = []
let g:unite_data_directory = expand('$VIM_HOME/.cache/unite')
let g:unite_source_bookmark_directory = expand('$VIM_HOME/.cache/unite/bookmark')
let g:unite_enable_auto_select = 1
let g:unite_source_file_async_command = "ls -la"

" 很多功能已由Leaderf取而代之
let g:unite_ignore_source_files = [
    \ "action.vim",
    \ "alias.vim",
    \ "bookmark.vim",
    \ "buffer.vim",
    \ "command.vim",
    \ "directory.vim",
    \ "file.vim",
    \ "file_list.vim",
    \ "file_point.vim",
    \ "find.vim",
    \ "function.vim",
    \ "grep.vim",
    \ "grep_git.vim",
    \ "history_input.vim",
    \ "history_unite.vim",
    \ "interactive.vim",
    \ "jump.vim",
    \ "jump_point.vim",
    \ "launcher.vim",
    \ "line.vim",
    \ "output.vim",
    \ "process.vim",
    \ "rec.vim",
    \ "resume.vim",
    \ "script.vim",
    \ "tab.vim",
    \ "vimgrep.vim",
    \ "window.vim",
    \ "window_gui.vim",
\]

"""
  " \ "change.vim",
  " \ "source.vim",
  " \ "mapping.vim",
  " \ "menu.vim",
  " \ "register.vim",
  " \ "runtimepath.vim",
  " \ "output_shellcmd.vim",
  " \ "quickfix",
"""

if executable('ag')
  " Use ag (the silver searcher)
  " https://github.com/ggreer/the_silver_searcher
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts =
  \ '-i --vimgrep --hidden --ignore ' .
  \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
  let g:unite_source_grep_recursive_opt = ''
else
    let g:unite_source_grep_default_opts = '-iRHn'
endif

" tag
let g:unite_source_tag_max_name_length = 26
let g:unite_source_tag_max_kind_length = 8

let g:unite_source_menu_menus = {
    \   "default" : {
    \       "description" : "shortcut for unite-menu",
    \       "command_candidates" : [
    \           ["1. Open vim configure", "NERDTree $VIM_HOME"],
    \           ["2. Update project tag", "MyUpdateTags $TAG_HOME"],
    \       ],
    \   },
    \}

"matcher_fuzzy
call unite#filters#matcher_default#use(['matcher_regexp'])
call unite#filters#sorter_default#use(['sorter_rank'])

let s:my_mrufilter = {
    \   "name" : "my_mru_filter",
    \   "description" : "Add my mru filter"
    \ }
function! s:my_mrufilter.filter(candidates, context)
    let i = 1
    for candidate in filter(copy(a:candidates), "!has_key(v:val, 'abbr')")
        let path = candidate.action__path
        let candidate.abbr = printf("%3d: ", i)
        let candidate.abbr .= "(" . fnamemodify(path, ":t") . ")"
        let candidate.abbr .= "  " . path . " "
        let candidate.abbr .= strftime(g:unite_source_buffer_time_format, getftime(path))
        let i = i + 1
    endfor
    return a:candidates
endfunction
call unite#define_filter(s:my_mrufilter)
unlet s:my_mrufilter

let s:my_open_dir = {'is_selectable' : 1}
function! s:my_open_dir.func(candidate)
    execute NERDTree fnameescape(a:candidate.word)
endfunction
call unite#custom#action('directory_mru', 'switch', s:my_open_dir)
unlet s:my_open_dir

let s:my_open_file = {'is_selectable' : 1}
function! s:my_open_file.func(candidates)
    if len(a:candidates) != 1
        return
    endif
    let linestr = get(a:candidates[0], 'action__text', a:candidates[0].word)
    try
        let [_, pattern, line; __] = matchlist(linestr, '\s*\([^:]\+\):\~*\(\d*\).*$')
        if filereadable(pattern)
            exec 'edit ' . pattern
            if line != ''
                exec line
            endif
        endif
    catch
    endtry
endfunction
call unite#custom#action('source/output/shellcmd/word', 'yank', s:my_open_file)
unlet s:my_open_file


call unite#custom#source(
    \ 'file_mru, directory_mru',
    \ 'converters',
    \ ['my_mru_filter'])

call unite#custom#profile(
    \ 'default',
    \ 'context',
    \ {
        \ 'winheight': 30,
        \ 'winwidth': 80,
        \ 'direction': 'dynamictop',
        \ 'verbose': 1,
        \ 'vertical': 0,
        \ 'horizontal': 1,
        \ 'prompt_direction': 'top',
        \ 'update_time' : 250,
        \ 'auto_resize' : 0,
        \ 'max_multi_lines' : 5,
        \ 'multi_line' : 0,
    \ })

call unite#custom#profile(
    \ 'files',
    \ 'filters',
    \ 'sorter_rank')

call unite#custom#profile(
    \ 'leftview',
    \ 'context',
    \ {
        \ 'winwidth': 36,
        \ 'direction': 'aboveleft',
        \ 'vertical': 1,
        \ 'horizontal': 0,
    \ })

call unite#custom#profile(
    \ 'gotofile',
    \ 'context',
    \ {
    \    'default-action': 'jump',
    \ })

call unite#custom#source(
    \ 'file_rec, file_rec/async, file_rec/git',
    \ 'max_candidates',
    \ 1000)

call unite#custom#source(
    \ 'file_mru, directory_mru',
    \ 'max_candidates',
    \ 120)

call unite#custom#source(
    \ 'buffer, file_rec, file_rec/git',
    \ 'matchers',
    \ ['converter_relative_word', 'matcher_fuzzy', 'matcher_project_ignore_files'])

call unite#custom#source(
    \ 'file_rec/async',
    \ 'matchers',
    \ ['converter_relative_word', 'matcher_default'])

call unite#custom#source(
    \ 'file_rec, file_rec/async, file_rec/git',
    \ 'converters',
    \ ['converter_file_directory'])

call unite#custom#source(
    \ 'file_rec, file_rec/async',
    \ 'required_pattern_length',
    \ 2)

call unite#custom#source(
    \ 'file_rec',
    \ 'sorters',
    \ 'sorter_length')

call unite#custom#source(
    \ 'file_rec, file_rec/async',
    \ 'ignore_globs',
    \ ['*.o', '*.obj', '*.class'])

call unite#custom#source(
    \ 'file_rec, file_rec/async',
    \ 'white_globs',
    \ ['R.class'])

let g:unite_prompt = '>>> '

function! s:unite_my_settings()
  nmap <buffer> <ESC> <Plug>(unite_exit)
  imap <buffer> <ESC> <Plug>(unite_exit)
  nmap <buffer> <C-C> <Plug>(unite_exit)
  imap <buffer> <C-C> <Plug>(unite_exit)
  " imap <buffer> jj  <Plug>(unite_insert_leave)
  imap <buffer> <TAB> <Plug>(unite_insert_leave)
  " nmap <buffer> <TAB>   <Plug>(unite_loop_cursor_down)
  " nmap <buffer> <S-TAB> <Plug>(unite_loop_cursor_up)
  imap <buffer> <C-A> <Plug>(unite_choose_action)
  imap <buffer> <C-U> <Plug>(unite_delete_backward_word)
  imap <buffer> <C-U> <Plug>(unite_delete_backward_path)
  " imap <buffer> '     <Plug>(unite_quick_match_default_action)
  " nmap <buffer> '     <Plug>(unite_quick_match_default_action)
  nmap <buffer> <C-R> <Plug>(unite_redraw)
  imap <buffer> <C-U> <Plug>(unite_redraw)
  inoremap <silent><buffer><expr> <C-T> unite#do_action('tabopen')
  nnoremap <silent><buffer><expr> <C-T> unite#do_action('tabopen')
  inoremap <silent><buffer><expr> <C-X> unite#do_action('split')
  nnoremap <silent><buffer><expr> <C-X> unite#do_action('split')
  inoremap <silent><buffer><expr> <C-V> unite#do_action('vsplit')
  nnoremap <silent><buffer><expr> <C-V> unite#do_action('vsplit')

  " p		|<Plug>(unite_smart_preview)|

  let unite = unite#get_current_unite()
  if unite.buffer_name =~# '^search'
      nnoremap <silent><buffer><expr> r     unite#do_action('replace')
  else
      nnoremap <silent><buffer><expr> r     unite#do_action('rename')
  endif
endfunction
autocmd FileType unite call s:unite_my_settings()
"}}}


" Warning conflict with LeaderF and fuzzfinder
" see fuzzfinder: su sU, si, sI
" nnoremap <silent> [search]Y :<C-u>UniteBookmarkAdd %<CR>
" nnoremap <silent> [search]y :<C-u>Unite -buffer-name=bookmark -no-empty bookmark<CR>
" nnoremap <silent> [search]f :<C-u>Unite -buffer-name=files -no-empty -start-insert file_rec/async<CR>
" nnoremap <silent> [search]d :<C-u>Unite -buffer-name=mru -default-action=switch directory_mru<CR>
" nnoremap <silent> [search]g :<C-u>UniteWithCursorWord -buffer-name=grep grep:%<CR>
" nnoremap <silent> [search]x :<C-u>Unite -buffer-name=change change<CR>
" nnoremap <silent> [search]n :<C-u>Unite -buffer-name=mru file_mru<CR>
" nnoremap <silent> [search]b :<C-u>Unite -buffer-name=buffer buffer<CR>
" nnoremap <silent> [search]R :<C-u>Unite -buffer-name=files -no-split -no-empty -start-insert file_rec/git<CR>
" nnoremap <silent> [search]f :<C-u>Unite -buffer-name=find find:.<CR>
" nnoremap <unique> <silent> [search]j :<C-u>Unite -buffer-name=jump -no-split -immediately jump_point<CR>

nnoremap <unique> <silent> [search]a :<C-u>Unite -buffer-name=source -no-empty source<CR>
nnoremap <unique> <silent> [search]v :<C-u>Unite -buffer-name=keymap mapping<CR>
nnoremap <unique> <silent> [search]m :<C-u>Unite -buffer-name=menu -profile-name=leftview menu:default<CR>
nnoremap <unique> <silent> [search]q :<C-u>Unite -buffer-name=register register<CR>
nnoremap <unique> <silent> [search]x :<C-u>Unite -buffer-name=change -no-empty change<CR>
nnoremap <unique> <silent> [search]e :<C-u>UniteResume<CR>

" 寄存器:help reg
"
" Read-only registers ":, ". and "%
	".	Contains the last inserted text
	"%	Contains the name of the current file!ls.
	":	Contains the most recent executed command-line.

" Alternate file register "#
"    Contains the name of the alternate file for the current window

" Selection and drop registers "*, "+ and "~
    " '+' 右击复制的数据
    " '*' 双击复制的数据
