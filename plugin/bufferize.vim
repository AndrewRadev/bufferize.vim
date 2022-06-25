if exists('g:loaded_bufferize') || &cp
  finish
endif

let g:loaded_bufferize = '0.1.0' " version number
let s:keepcpo = &cpo
set cpo&vim

if !exists('g:bufferize_command')
  let g:bufferize_command = 'new'
endif

if !exists('g:bufferize_keep_buffers')
  let g:bufferize_keep_buffers = 0
endif

if !exists('g:bufferize_focus_output')
  let g:bufferize_focus_output = 0
endif

command! -nargs=* -complete=command Bufferize call bufferize#Run(<q-args>, '<mods>')
command! -nargs=* -complete=command BufferizeSystem <mods> Bufferize echo system(<q-args>)
command! -nargs=* -complete=command BufferizeTimer call bufferize#RunWithTimer(<q-args>, '<mods>')

let &cpo = s:keepcpo
unlet s:keepcpo
