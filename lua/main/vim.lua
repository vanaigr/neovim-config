vim.cmd [==[

" silent! is added so that mappings do not abort

function! PrintError(msg) abort
    execute 'normal! \<Esc>'
    echohl ErrorMsg
    echomsg a:msg
    echohl None
endfunction

" https://gist.github.com/statox/5b79f7e72ca650ed0a26ae1bdfea35eb
function! SetVisualSelect(start, end)
    execute "silent! normal! \v\<Esc>"
    if &selection == 'exclusive'
        let a:end[1] += 1
    endif
    call setpos("'<", [ 0, a:start[0], a:start[1] ])
    call setpos("'>", [ 0, a:end[0], a:end[1] ])
    norm! gv
endfunction
function! SetVisualLines(start, end)
    execute "silent! normal! \V\<Esc>"
    call setpos("'<", [0, a:start[0], a:start[1]])
    call setpos("'>", [0, a:end[0], a:end[1]])
    norm! gv
endfunction

" doesn't consider string literals
"
" direction = 0, start from beginning of the line
" direction = 1, search forward
" direction = 2, search backwards
fun! SelectVariableValue(direction) 
    let startL = line('.')
    let searchPattern = '\M\(=\@<!==\@!\|:\@<!::\@!\)'
    if !a:direction
        call cursor(startL, 1)
        keepjumps let lin = search(searchPattern, 'Wc', startL)
    else
        let [forwFlags, backFlags] = (a:direction == 1 ? ['Wc', 'Wcb'] : ['Wcb', 'Wc'])
        keepjumps let lin = search(searchPattern, forwFlags, startL)
        if !lin | keepjumps let lin = search(searchPattern, backFlags, startL) | endif
    endif
    if !lin | call PrintError('Could not find variable declaration') | return | endif

    keepjumps let selectStart = searchpos('\M\S', 'Ws')
    let [skipCur, curL, curC] = [v:false, line('.'), col('.')]
    while v:true
        keepjumps let [curL, curC] = searchpos('\M\((\|{\|[\|;\|,\)', (skipCur ? 'W' : 'Wc'), line('.'))
        if !curL | let [curL, curC] = [line('.'), strlen(getline('.'))] | break | endif
        let curChar = nr2char(strgetchar(getline(curL)[curC - 1:], 0))
        if curChar == '(' || curChar == '{' || curChar == '[' 
            keepjumps silent! normal! %
            let skipCur = curL == line('.') && curC == col('.')
        else | let curC = curC-1 | break | endif
    endwhile
    call SetVisualSelect(selectStart, [curL, curC])
endfun

fun! ExecDelLines(dir) 
    let startPos = [line('.'), col('.')]
    let saveView = winsaveview()
    call SelectVariableValue(a:dir)
    let endPos = [line('.'), col('.')]
    silent! normal! d
    call winrestview(saveView)
    call SetVisualLines(startPos, [line('.'), col('.')])
    silent! normal! "_dd
endfun

fun! GoToFunctionDecl()
    let saveView = winsaveview()
    let startPos = getpos('.')

    let i = 1
    while i <= 10
        exec 'silent! normal! v'.i.'abOvh'
        if mode() != 'n' | break | endif
        let pPos = getpos('.')[1:2]
        let namePos = searchpos('\M\w(', 'Wcn', pPos[0])
        if pPos[0] == namePos[0] && pPos[1] == namePos[1]
            " lsp can rebind gd
            keepjumps normal gd
            return
        endif
        call setpos('.', startPos)
        let i += 1
    endwhile

    call winrestview(saveView)
    call PrintError('Could not find function name') 
endfun

function! FindCapitalWord()
    let startPos = getpos('.')

    let [line, col] = searchpos('\C\v(([A-Z][A-Z]([^A-Z]|$))|[a-z]([^a-z]|$))', 'Wnc')
    if line != 0 
        call setpos('.', [startPos[0], line, col, 0])

        let [pline, pcol] = searchpos('\C\v(([^A-Z]|^)[A-Z]|\W[a-z]|([^a-z]|^)([a-z])@=)', 'nWbe', startPos[1])
        if pline != 0 && pcol != col
            return [v:true, [pline, pcol], [line, col]]
        endif
    endif

    echoerr 'Word not found on current line'
    return [v:false]
endfunction

function! SelectCapitalWord()
    let result = FindCapitalWord()
    if result[0]
        call SetvisualSelect(result[1], result[2])
    else
    endif
endfunction


function! MoveCapitalWord()
    let startPos = getpos('.')
    let result = FindCapitalWord()
    if result[0]
        if result[1][0] < startPos[1] || (result[1][0] == startPos[1] && result[1][1] <= startPos[2])
            call setpos('.', [startPos[0], result[2][0], result[2][1]+1, 0])
            let result = FindCapitalWord()
        endif
    endif

    if result[0]
        call setpos('.', [startPos[0], result[1][0], result[1][1], 0])
    endif
endfunction

" https://stackoverflow.com/a/6271254
function! GetVisualSelection()
    return GetBufferText(
        getpos("'<")[1:2],
        getpos("'>")[1:2]
    )
endfunction
function! GetBufferText(startPos, endPos)
    let [line_start, column_start] = a:startPos
    let [line_end, column_end] = a:endPos

    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

" https://vi.stackexchange.com/a/5805/49277
function! AdjustFontSize(amount)
    let s:pattern = '\v^(.{-})([1-9][0-9]*)$'
    let s:minfontsize = 4
    let s:maxfontsize = 20

    if has("gui_running")
        let fontname = substitute(&guifont, s:pattern, '\1', '')
        let cursize = substitute(&guifont, s:pattern, '\2', '')
        let newsize = cursize + a:amount
        if (newsize >= s:minfontsize) && (newsize <= s:maxfontsize)
            let newfont = fontname . newsize
            exec 'GuiFont!' newfont
            return
        endif
    endif

    call PrintError('Could not change font size')
endfunction
]==]
