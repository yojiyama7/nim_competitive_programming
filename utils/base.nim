import strutils
import sequtils
import strscans
import macros

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

# proc input(): string =
#   stdin.readLine
# proc inputs(): seq[string] =
#   stdin.readline.split
# proc inputInt(): int =
#   stdin.readLine.parseInt
# proc inputInts(): seq[int] =
#   stdin.readLine.split.map(parseInt)
# proc inputValues(s: string): tuple =
#   stdin.readLine.scanTuple(s)

var n: int

# text
let A = stdin.readLine
echo A

# int
let B = stdin.readLine.parseInt
echo B

# texts
let C = stdin.readLine.split
echo C

# ints
let D = stdin.readLine.split.map(parseInt)
echo D

# textList
n = stdin.readLine.parseInt
let E = newSeqWith(n, stdin.readLine)
echo E

# intList
n = stdin.readLine.parseInt
let F = newSeqWith(n, stdin.readLine.parseInt)
echo F

# textsList
n = stdin.readLine.parseInt
let G = newSeqWith(n, stdin.readLine.split)
echo G

# intsList
n = stdin.readLine.parseInt
let H = newSeqWith(n, stdin.readLine.split.map(parseInt))
echo H

# fixedLengthTexts
# tupleの0番目はsuccess(scanが成功したか否か)なので必ずtrueになっている(使わない)
let (_, I, J) = stdin.readLine.scanTuple("$+ $+")
echo I
echo J

# fixedLengthInts
let (_, K, L) = stdin.readLine.scanTuple("$i $i")
echo K
echo L

# fixedLengthValues
let (_, M, N) = stdin.readLine.scanTuple("$+ $i")
echo M
echo N

# fixedLengthValuesList
# これも各tupleの0番目がsuccessなので気をつける
n = stdin.readLine.parseInt
let O = newSeqWith(n, stdin.readLine.scanTuple("$+ $i"))
echo O
