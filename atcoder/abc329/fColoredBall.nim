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
  (N, Q) = stdin.readLine.split.map(parseInt).toTuple(2)
  C = stdin.readLine.split.map(parseInt)
  QUERY = newSeqWith(Q, stdin.readLine.split.map(parseInt).toTuple(2))

var boxes = C.mapIt([it].toHashSet())
var ownBoxes = (0..<N).toSeq
for (a1, b1) in QUERY:
  var (a, b) = (a1-1, b1-1)
  var (aa, bb) = (ownBoxes[a], ownBoxes[b])
  if boxes[aa].len < boxes[bb].len:
    for aax in boxes[aa]:
      boxes[bb].incl(aax)
    boxes[aa].clear()
  else:
    for bbx in boxes[bb]:
      boxes[aa].incl(bbx)
    boxes[bb].clear()
    swap(ownBoxes[a], ownBoxes[b])
    (aa, bb) = (ownBoxes[a], ownBoxes[b])
  echo boxes[bb].len()
