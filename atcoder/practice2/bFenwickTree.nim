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

# fenwick tree
# .push(x)      : 要素を最後尾に追加
# .prefixSum(i) : i番目(0 or 1 idx)までの総和
# .add(i, a)    : i番目にaを加算
import bitops, sequtils

type
  FenwickTree[T: int or float] = object
    l: seq[T]

proc initFenwickTree[T: int or float](n: int): FenwickTree[T] =
  result.l = newSeq[T](n)
# proc `[]`[T: int or float](self: var FenwickTree[T], eidx) =

proc toFenwickTree[T: int or float](l: openArray[T]): FenwickTree[T] =
  result = initFenwickTree[T](l.len)
  for i, li in l:
    result.add(i, li)

proc sumFromOneTo[T: int or float](self: FenwickTree[T], bidx: int): int =
  var x = bidx
  while x > 0:
    result += self.l[x]
    x -= (x and -x)
proc sumOf[T: int or float](self: FenwickTree[T], slice: HSlice): int =
  let (l, r) = (slice.a, slice.b+1)
  self.sumFromOneTo(r) - self.sumFromOneTo(l)

proc add[T: int or float](self: var FenwickTree[T], eidx: int, v: int) =
  var x = eidx+1
  while x <= self.l.len:
    self.l[x] += v
    x += (x and -x)

let
  (N, Q) = stdin.readLine.split.map(parseInt).toTuple(2)
  A = stdin.readLine.split.map(parseInt)
  QUERY = newSeqWith(Q, stdin.readLine.split.map(parseInt))

var ft = A.toFenwickTree()
for query in QUERY:
  if query[0] == 0:
    let (p, x) = (query[1], query[2])
    ft.add(p, x)
  elif query[0] == 1:
    let (l, r) = (query[1], query[2])
    echo ft.sumOf(l..<r)
