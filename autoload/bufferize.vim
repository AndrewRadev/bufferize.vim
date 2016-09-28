function! bufferize#Run(cmd)
  let output = ''

  " Execute the command and get its output
  let cmd = a:cmd
  redir => output
  silent exe cmd
  redir END

  " Find an existing Bufferize buffer
  let bufferize_bufnr = bufferize#Bufnr(a:cmd)
  let current_buffer = bufnr('%')

  let cursor_at_last_line = 0

  if bufferize_bufnr > 0
    " There's an existing buffer, save the cursor position, but clear it out
    let saved_view = winsaveview()
    if line('.') == line('$')
      " it was the last line, so let's follow it
      let cursor_at_last_line = 1
    endif
    exe bufwinnr(bufferize_bufnr).'wincmd w'
    silent normal! gg0dG
  else
    " Create a new buffer
    new
    setlocal nowrap
    setlocal nonumber
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=delete
    exe 'file Bufferize:\ '.escape(a:cmd, ' ')
    let saved_view = winsaveview()
  endif

  " Fill the buffer with the command's output
  call setline(1, split(output, "\n"))
  set nomodified
  call winrestview(saved_view)
  if cursor_at_last_line
    silent normal! G
  endif
  if exists(':RunCommand')
    exe 'RunCommand silent Bufferize '.a:cmd
  endif
  exe bufwinnr(current_buffer).'wincmd w'
endfunction

function! bufferize#RunWithTimer(args)
  if !has('timers') || !has('lambda')
    echohl WarningMsg |
          \ echomsg "BufferizeTimer can only be used with a Vim that has +timers and +lambda" |
          \ echohl None
    return
  endif

  if a:args !~ '^\d\+ '
    echoerr "The first argument needs to be a number: ".a:args
    return
  endif

  let interval = str2nr(matchstr(a:args, '^\d\+\ze'))
  let command  = matchstr(a:args, '^\d\+\s*\zs.*')

  if bufferize#Bufnr(command)
    " already set, ignore it
    return
  endif

  silent call bufferize#Run(command)
  call s:SetBufferUpdater(bufferize#Bufnr(command), {-> bufferize#Run(command)}, interval)
endfunction

function! bufferize#Bufnr(command)
  for bufnr in tabpagebuflist()
    if bufname(bufnr) =~ 'Bufferize: '.a:command
      return bufnr
      break
    endif
  endfor

  return 0
endfunction

" Invokes a:callback every a:interval milliseconds in the buffer, given by
" a:bufnr. If the buffer is closed, the timer is cancelled.
function! s:SetBufferUpdater(bufnr, callback, interval)
  let timer_id = timer_start(a:interval, a:callback, {"repeat": -1})
  augroup buffer_updater
    autocmd!
    exe 'autocmd BufUnload <buffer='.a:bufnr.'> call timer_stop('.timer_id.')'
  augroup END
endfunction
