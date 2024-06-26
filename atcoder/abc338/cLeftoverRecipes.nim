import std/[sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables, complex, random, deques, heapqueue, sets, macros, bitops]
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
proc parseInt(c: char): int =
  c.int - '0'.int
iterator skipBy(r: HSlice, step: int): int =
  for i in countup(r.a, r.b, step):
    yield i
proc initHashSet[T](): Hashset[T] = initHashSet[T](0)

################################

let INF = 1 shl 60
let
  N = stdin.readLine.parseInt()
  Q = stdin.readLine.split.map(parseInt)
  A = stdin.readLine.split.map(parseInt)
  B = stdin.readLine.split.map(parseInt)

# 料理Aを何個作るかを全探索
var result = 0
block solve:
  for i in 0..<INF:
    var remains = newSeq[int](N)
    for j in 0..<N:
      remains[j] = Q[j] - A[j]*i
      if remains[j] < 0:
        break solve
    let bScore = (0..<N).toSeq.mapIt(
      if B[it] == 0:
        INF
      else:
        remains[it] div B[it]
      ).min()
    let score = i + bScore
    result = max(result, score)

echo result