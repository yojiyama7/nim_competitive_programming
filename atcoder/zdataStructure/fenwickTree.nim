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

type
  ObjFenwickTree = object
    l: seq[int]
  FenwickTree = ref ObjFenwickTree

proc lsb(x: int): int =
  return x and -x
proc initFenwickTree(n: int): FenwickTree =
  FenwickTree(l: newSeq[int](n+1))
proc push(self: FenwickTree, v: int) =
  let n = self.l.len()
  let nLsb = lsb(n)
  var x = v
  var d = 1  
  while d != nLsb:
    x += self.l[n-d]
    d *= 2
proc sumFromOneTo(self: FenwickTree, bidx: int): int =
  var x = bidx
  while x > 0:
    result += self.l[x]
    x -= lsb(x)
proc sumOf(self: FenwickTree, slice: HSlice[int, int]): int =
  let (a, b) = (slice.a, slice.b+1)
  self.sumFromOneTo(b) - self.sumFromOneTo(a)
proc add(self: FenwickTree, eidx: int, v: int) =
  var x = eidx + 1
  while x < self.l.len():
    self.l[x] += v
    x += lsb(x)

when isMainModule:
  var ft = initFenwickTree(10)

  for i in 0..<10:
    ft.add(i, i+1)
  for i in 0..10:
    echo ft.sumFromOneTo(i)
  for i in 0..10-2:
    echo ft.sumOf(i..<i+2)
