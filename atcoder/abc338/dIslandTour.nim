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

let 
  (N, M) = stdin.readLine.split.map(parseInt).toTuple(2)
  X1 = stdin.readLine.split.map(parseInt)

proc calcDist(route: seq[(int, int)]): int =
  for (l, r) in route:
    result += r - l

var edgeScorePoint = newSeqWith(N+1, 0)
var stdCost = 0
for i in 0..<M-1:
  var a = X1[i]-1
  var b = X1[i+1]-1
  if a > b: swap(a, b)
  let distA = b - a
  stdCost += distA
  let distB = N-distA
  let dd = distB-distA
  edgeScorePoint[a] += dd
  edgeScorePoint[b] -= dd

# imos法
let edgeScore = edgeScorePoint.cumsummed()
let result = stdCost + edgeScore.min()
echo result
