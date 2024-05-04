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

let (N, M, K) = stdin.readLine.split.map(parseInt).toTuple(3)

let lcmNM = lcm([N, M])
let cntPerChunk = (lcmNM div N) + (lcmNM div M) - 2

var (ng, ok) = (0, lcmNM * (K.ceilDiv(cntPerChunk))+1)
while abs(ok - ng) > 1:
  let mid = (ok + ng) div 2
  # echo (mid, (mid div N), (mid div M), (mid div lcmNM))
  if (mid div N) + (mid div M) - (mid div lcmNM)*2 < K:
    ng = mid
  else:
    ok = mid
  # echo (ng, ok)

echo ok