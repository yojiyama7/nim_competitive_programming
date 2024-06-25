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

type FenwickTree[T] = object 
  l*: seq[T]
proc extractLowestBit(x: int): int = x and -x
proc initFenwickTree*[T](): FenwickTree[T] =
  FenwickTree[T](l: newSeq[T](1))
proc push*[T](self: var FenwickTree[T], xRaw: T) =
  let n = self.l.len
  let k = extractLowestBit(n)
  var x = xRaw
  var d = 1
  echo (k, n, d)
  while d != k:
    x += self.l[n - d]
    d *= 2
  self.l.add(x)
proc sumFromOneTo[T](self: var FenwickTree[T], bi: int): T =
  var rbidx = bi
  while rbidx != 0:
    result += self.l[rbidx]
    rbidx -= extractLowestBit(rbidx)
proc sumOf[T](self: var FenwickTree[T], lr: Slice[int]): T =
  let (l, r) = (lr.a, lr.b+1)
  return self.sumFromOneTo(r) - self.sumFromOneTo(l)
proc add[T](self: var FenwickTree[T], ei: int, v: T) =
  var bi = ei+1
  while bi < self.l.len:
    self.l[bi] += v
    bi += extractLowestBit(bi)

################################

when isMainModule:
  import unittest
  var ft = initFenwickTree[int]()
  for i in 1..10:
    ft.push(i)
  echo ft.l

  for i in 0..<10:
    echo ft.sumOf(i..i)