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
    normal! gg0dG
  else
    " Create a new buffer
    new
    setlocal nowrap
    setlocal nonumber
    setlocal buftype=nofile
    let saved_view = winsaveview()
  endif

  " Set the filename and fill the buffer with the command's output
  exe 'file Bufferize:\ '.escape(a:cmd, ' ')
  call setline(1, split(output, "\n"))
  set nomodified
  call winrestview(saved_view)
  if cursor_at_last_line
    normal! G
  endif
  if exists(':RunCommand')
    exe 'RunCommand silent Bufferize '.a:cmd
  endif
  exe bufwinnr(current_buffer).'wincmd w'
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
