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
proc parseInt(c: char): int =
  c.int - '0'.int
iterator skipBy(r: HSlice, step: int): int =
  for i in countup(r.a, r.b, step):
    yield i

################################

let
  (N, M) = stdin.readLine.split.map(parseInt).toTuple(2)
  A = stdin.readLine.split.map(parseInt)

var
  accA = newSeqWith(N+1, 0)
for i, a in A:
  accA[i+1] = accA[i] + a
var score = 0
for i in 0..<M:
  score += (i+1) * A[i]
var result = score
for i in 1..<(N-M+1):
  let (l, r) = (i-1, i-1 + M)
  score -= accA[r] - accA[l]
  score += A[r] * M
  result = max(result, score)

echo result
