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
  (N, L) = stdin.readLine.split.map(parseInt).toTuple(2)
  K = stdin.readLine.parseInt()
  A = stdin.readLine.split.map(parseInt)

proc isOk(x: int): bool = 
  var ba = 0
  var cnt = 0
  for a in A:
    if a - ba >= x:
      ba = a
      cnt += 1
  if L - ba >= x:
    cnt += 1
  return cnt >= K+1

var (ok, ng) = (0, L + 1)
while abs(ok - ng) > 1:
  let mid = (ok + ng) div 2
  if isOk(mid):
    ok = mid
  else:
    ng = mid

echo ok
