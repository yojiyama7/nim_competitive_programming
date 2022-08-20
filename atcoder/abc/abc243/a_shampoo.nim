import sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables
import complex, random, deques, heapqueue, sets, macros
{.warning[UnusedImport]: off.}

macro scanTuple*(input: untyped; pattern: static[string]; matcherTypes: varargs[untyped]): untyped =
# macro scanTuple*(input: untyped; pattern: static[string]; matcherTypes: varargs[untyped]): untyped {.since: (1, 5).}=
  ## Works identically as scanf, but instead of predeclaring variables it returns a tuple.
  ## Tuple is started with a bool which indicates if the scan was successful
  ## followed by the requested data.
  ## If using a user defined matcher, provide the types in order they appear after pattern:
  ## `line.scanTuple("${yourMatcher()}", int)`
  runnableExamples:
    let (success, year, month, day, time) = scanTuple("1000-01-01 00:00:00", "$i-$i-$i$s$+")
    if success:
      assert year == 1000
      assert month == 1
      assert day == 1
      assert time == "00:00:00"
  var
    p = 0
    userMatches = 0
    arguments: seq[NimNode]
  result = newStmtList()
  template addVar(typ: string) =
    let varIdent = ident("temp" & $arguments.len)
    result.add(newNimNode(nnkVarSection).add(newIdentDefs(varIdent, ident(typ), newEmptyNode())))
    arguments.add(varIdent)
  while p < pattern.len:
    if pattern[p] == '$':
      inc p
      case pattern[p]
      of 'w', '*', '+':
        addVar("string")
      of 'c':
        addVar("char")
      of 'b', 'o', 'i', 'h':
        addVar("int")
      of 'f':
        addVar("float")
      of '{':
        if userMatches < matcherTypes.len:
          let varIdent = ident("temp" & $arguments.len)
          result.add(newNimNode(nnkVarSection).add(newIdentDefs(varIdent, matcherTypes[userMatches], newEmptyNode())))
          arguments.add(varIdent)
          inc userMatches
      else: discard
    inc p
  result.add newPar(newCall(ident("scanf"), input, newStrLitNode(pattern)))
  for arg in arguments:
    result[^1][0].add arg
    result[^1].add arg
  result = newBlockStmt(result)

template newSeqWith*(len: int, init: untyped): untyped =
  var result = newSeq[typeof(init, typeOfProc)](len)
  for i in 0 ..< len:
    result[i] = init
  move(result) # refs bug #7295

################################

