import sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables
import complex, random, deques, heapqueue, sets, macros
{. warning[UnusedImport]: off, hint[XDeclaredButNotUsed]: off .}

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

# since (1, 1):
template countIt*(s, pred: untyped): int =
  ## Returns a count of all the items that fulfill the predicate.
  ##
  ## The predicate needs to be an expression using
  ## the `it` variable for testing, like: `countIt(@[1, 2, 3], it > 2)`.
  ##
  runnableExamples:
    let numbers = @[-3, -2, -1, 0, 1, 2, 3, 4, 5, 6]
    iterator iota(n: int): int =
      for i in 0..<n: yield i
    assert numbers.countIt(it < 0) == 3
    assert countIt(iota(10), it < 2) == 2

  var result = 0
  for it {.inject.} in s:
    if pred: result += 1
  result

################################

let
  N = stdin.readLine.parseInt
  A = stdin.readLine.split.map(parseInt)
  B = stdin.readLine.split.map(parseInt)

let allCount = (A.toHashSet * B.toHashSet).len
let samePosCount = zip(A, B).countIt(it[0] == it[1])

echo samePosCount
echo allCount - samePosCount
