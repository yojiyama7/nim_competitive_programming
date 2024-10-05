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

const INF = 1 shl 60
let
  (N1, N2, M) = stdin.readLine.split.map(parseInt).toTuple(3)
  AB = newSeqWith(M, stdin.readLine.split.map(parseInt).toTuple(2))

var g = newSeqWith(N1+N2, initHashSet[int]())
for (a1, b1) in AB:
  let (a, b) = (a1-1, b1-1)
  g[a].incl(b)
  g[b].incl(a)

var dist = newSeqWith(N1+N2, INF)

var aMaxDist = 0
var s = [0].toDeque()
dist[0] = 0
while s.len > 0:
  let t = s.popFirst()
  for c in g[t]:
    if dist[c] <= dist[t] + 1:
      continue
    dist[c] = dist[t] + 1
    aMaxDist = max(aMaxDist, dist[c])
    s.addLast(c)

s = [N1+N2-1].toDeque()
dist[N1+N2-1] = 0
var bMaxDist = 0
while s.len > 0:
  let t = s.popFirst()
  for c in g[t]:
    if dist[c] <= dist[t] + 1:
      continue 
    dist[c] = dist[t] + 1
    bMaxDist = max(bMaxDist, dist[c])
    s.addLast(c)

let result = aMaxDist + 1 + bMaxDist
echo result