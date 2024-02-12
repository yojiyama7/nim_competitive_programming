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
  (N, M) = stdin.readLine.split.map(parseInt).toTuple(2)
var
  A = stdin.readLine.split.map(parseInt)

A.sort()
# echo A

var
  lIdx = 0
  rIdx = 0
  maxScore = 0
while lIdx < N:
  while rIdx < N and A[rIdx] - A[lIdx] < M:
    # echo (lIdx, rIdx), (A[lIdx], A[rIdx])
    rIdx += 1
  maxScore = max(maxScore, rIdx - lIdx)
  lIdx += 1

echo maxScore
