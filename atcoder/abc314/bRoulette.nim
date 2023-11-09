import std/[sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables, complex, random, deques, heapqueue, sets, macros]
{. warning[UnusedImport]: off, hint[XDeclaredButNotUsed]: off, hint[Name]: off .}

macro toTuple(lArg: openArray, n: static[int]): untyped =
  let l = genSym()
  var t = newNimNode(nnkTupleConstr)
  for i in 0..<n:
    t.add quote do:
      `l`[`i`]
  quote do:
    (let `l` = `lArg`; `t`)
proc pow(x, n, m: int): int =
  if n == 0:
    return 1
  if n mod 2 == 1:
    result = x * pow(x, n-1, m)
  else:
    result = pow(x, n div 2, m)^2
  result = result mod m

################################

let 
  N = stdin.readLine.parseInt()
  CA = newSeqWith(N, (
    stdin.readLine.parseInt(),
    stdin.readLine.split.map(parseInt).toHashSet()
  ))
  X = stdin.readLine.parseInt()

var l: seq[(int, HashSet[int], int)] = @[]
for i, (c, a) in CA:
  l.add((c, a, i))
l = l.filterIt(X in it[1])
if l.len == 0:
  echo 0
  echo ""
  quit()
let cMin = l.min()[0]
l = l.filterIt(it[1].len == cMin)
let result = l.mapIt(it[2] + 1)
echo result.len
echo result.join(" ")
