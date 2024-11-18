if exists("b:current_syntax")
  finish
endif

syntax match BekkenResultBufferDirectory /\v(^.{6})\s(.{1})\s(.{60})\s(.*$)/ oneline
syntax match BekkenResultBufferFilename /\v(^.{6})\s(.{1})\s(.{60})/ contained containedin=BekkenResultBufferDirectory oneline
syntax match BekkenResultBufferStatus /\v(^.{6})\s(.{1})/ contained containedin=BekkenResultBufferFilename oneline
syntax match BekkenResultBufferBufnr /\v(^.{6})/ contained containedin=BekkenResultBufferStatus oneline

highlight def link BekkenResultBufferDirectory Directory
highlight def link BekkenResultBufferFilename Title
highlight def link BekkenResultBufferStatus Normal
highlight def link BekkenResultBufferBufnr Number

let b:current_syntax = "bekken-result-buffer"
