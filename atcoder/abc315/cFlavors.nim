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
  F1S = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(2))

var t = initTable[int, seq[int]]()
for (f1, s) in F1S:
  let f = f1-1
  if not t.hasKey(f):
    t[f] = newSeq[int]()
  t[f].add(s)
for tk in t.keys:
  t[tk].sort()

var maxScore = 0
# 同じ味
for tk in t.keys:
  if t[tk].len >= 2:
    let score = t[tk][^1] + (t[tk][^2] div 2)
    maxScore = max(maxScore, score)
# 違う味
let maxsByFlavor = t.values.toSeq.mapIt(it[^1])
if maxsByFlavor.len >= 2:
  let score = maxsByFlavor.sorted()[^2 ..< ^0].sum()
  maxScore = max(maxScore, score)

echo maxScore
