vim.cmd [==[

function! PrintError(msg) abort
    execute 'normal! \<Esc>'
    echohl ErrorMsg
    echomsg a:msg
    echohl None
endfunction

" https://gist.github.com/statox/5b79f7e72ca650ed0a26ae1bdfea35eb
function! SetVisualSelect(start, end)
    execute "norm! \v\<Esc>"
    call setpos("'<", [ 0, a:start[0], a:start[1] ])
    call setpos("'>", [ 0, a:end[0], a:end[1] ])
    norm! gv
endfunction
function! SetVisualLines(start, end)
    execute "norm! \V\<Esc>"
    call setpos("'<", [0, a:start[0], a:start[1]])
    call setpos("'>", [0, a:end[0], a:end[1]])
    norm! gv
endfunction

" doesn't consider string literals
"
" direction = 0, start from beginning of the line
" direction = 1, search forward
" direction = 2, search backwards
fun SelectVariableValue(direction) 
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
            keepjumps normal! %
            let skipCur = curL == line('.') && curC == col('.')
        else | let curC = curC-1 | break | endif
    endwhile
    call SetVisualSelect(selectStart, [curL, curC])
endfun

fun ExecDelLines(dir) 
    let startPos = [line('.'), col('.')]
    let saveView = winsaveview()
    call SelectVariableValue(a:dir)
    let endPos = [line('.'), col('.')]
    norm! d
    call winrestview(saveView)
    call SetVisualLines(startPos, [line('.'), col('.')])
    norm! "_dd
endfun

fun! GoToFunctionDecl()
    let saveView = winsaveview()
    normal! \<Esc>
    let startPos = getpos('.')
    
    "note: running   :normal! vabv   outside of any () leaves you in visual mode for some weird reason

    let i = 1
    while i <= 10
        exec 'normal! v'.i.'abOvh'
        if mode() != 'n' | break | endif
        let pPos = getpos('.')[1:2]
        let namePos = searchpos('\M\w(', 'Wcn', pPos[0])
        if pPos[0] == namePos[0] && pPos[1] == namePos[1]
            keepjumps normal! gd
            return
        endif
        call setpos('.', startPos)
        let i += 1
    endwhile

    if mode() != 'n' | normal! v 
    endif
    redraw

    call winrestview(saveView)
    call PrintError('Could not find function name') 
endfun


]==]
