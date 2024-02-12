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
  N = stdin.readLine.parseInt()
var
  LR = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(2))

LR.sort()
var 
  ranges = newSeq[(int, int)]()
  lEnd = int.low
  rEnd = int.low
for (l, r) in LR:
  if l <= rEnd:
    rEnd = max(rEnd, r)
  else:
    ranges.add((lEnd, rEnd))
    lEnd = l
    rEnd = r
ranges.add((lEnd, rEnd))

for (l, r) in ranges[1..^1]:
  echo &"{l} {r}"
