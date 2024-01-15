when not declared ATCODER_READER_HPP:
  const ATCODER_READER_HPP* = 1
  import streams, strutils, sequtils
#  proc scanf*(formatstr: cstring){.header: "<stdio.h>", varargs.}
  #proc getchar(): char {.header: "<stdio.h>", varargs.}
#  proc nextInt*(): int = scanf("%lld",addr result)
#  proc nextFloat*(): float = scanf("%lf",addr result)
  proc nextString*(f:auto = stdin): string =
    var get = false
    result = ""
    while true:
      let c = f.readChar
      #doassert c.int != 0
      if c.int > ' '.int:
        get = true
        result.add(c)
      elif get: return
  proc nextInt*(f:auto = stdin): int = parseInt(f.nextString)
  proc nextFloat*(f:auto = stdin): float = parseFloat(f.nextString)
#  proc nextString*():string = stdin.nextString()

  proc toStr*[T](v:T):string =
    proc `$`[T](v:seq[T]):string =
      v.mapIt($it).join(" ")
    return $v
  
  proc print0*(x: varargs[string, toStr]; sep:string):string{.discardable.} =
    result = ""
    for i,v in x:
      if i != 0: addSep(result, sep = sep)
      add(result, v)
    result.add("\n")
    stdout.write result
  
  var print*:proc(x: varargs[string, toStr])
  print = proc(x: varargs[string, toStr]) =
    discard print0(@x, sep = " ")
