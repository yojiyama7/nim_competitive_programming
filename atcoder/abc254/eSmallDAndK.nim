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
  AB = newSeqWith(M, stdin.readLine.split.map(parseInt).toTuple(2))
  Q = stdin.readLine.parseInt()
  XK = newSeqWith(Q, stdin.readLine.split.map(parseInt).toTuple(2))

var g = newSeqWith(N, initHashSet[int]())
for (a1, b1) in AB:
  g[a1-1].incl(b1-1)
  g[b1-1].incl(a1-1)

for (x1, k) in XK:
  let x = x1-1
  var nodes = [x].toHashSet()
  for i in 0..<k:
    var nextNodes = initHashSet[int]()
    for n in nodes:
      nextNodes = nextNodes.union(g[n])
    nodes = nodes.union(nextNodes)
  # echo nodes
  echo nodes.mapIt(it+1).sum()
