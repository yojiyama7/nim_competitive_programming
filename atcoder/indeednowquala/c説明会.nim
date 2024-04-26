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

var
  N = stdin.readLine.parseInt()
  S = newSeqWith(N, stdin.readLine.parseInt())
let
  Q = stdin.readLine.parseInt()
  K = newSeqWith(Q, stdin.readLine.parseInt())

let maxS = S.max()

S.sort()
let zcnt = S.upperBound(0)
N -= zcnt
S = S[zcnt..^1]

for k in K:
  var (ng, ok) = (-1, maxS+1)
  while abs(ok-ng) > 1:
    let mid = (ok + ng) div 2
    # echo (mid, N, S.lowerBound(mid), k)
    if N - S.lowerBound(mid) <= k:
      ok = mid
    else:
      ng = mid
  echo ok
