import std/[sequtils, strutils, strformat, strscans, algorithm, math, sugar,
    hashes, tables, complex, random, deques, heapqueue, sets, macros, bitops]
{.warning[UnusedImport]: off, hint[XDeclaredButNotUsed]: off, hint[Name]: off.}

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

############################

let
  (H, W, X) = stdin.readLine.split.map(parseInt).toTuple(3)
  (P, Q) = stdin.readLine.split.map(parseInt).toTuple(2)
  S = newSeqWith(H, stdin.readLine.split.map(parseInt))

var isSeen = newSeqWith(H, newSeqWith(W, false))
var h = initHeapQueue[(int, int, int)]()
var size = S[P-1][Q-1]
isSeen[P-1][Q-1] = true
for (dx, dy) in [(1, 0), (0, 1), (-1, 0), (0, -1)]:
  let y = P-1+dy
  let x = Q-1+dx
  if (not (x in 0..<W and y in 0..<H)):
    continue
  if (isSeen[y][x]):
    continue
  isSeen[y][x] = true
  h.push((S[y][x], x, y))
# echo h
while (h.len > 0 and h[0][0] < ceilDiv(size, X)):
  let (s, cx, cy) = h.pop()
  size += s
  for (dx, dy) in [(1, 0), (0, 1), (-1, 0), (0, -1)]:
    let (x, y) = (cx+dx, cy+dy)
    if (not (x in 0..<W and y in 0..<H)):
      continue
    if (isSeen[y][x]):
      continue
    isSeen[y][x] = true;
    h.push((S[y][x], x, y))

echo size
