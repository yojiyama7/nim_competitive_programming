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

var
  (N, R) = stdin.readLine.split.map(parseInt).toTuple(2)
  DA = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(2))

for (d, a) in DA:
  if (d == 1 and R in 1600..<2800):
    R += a
  if (d == 2 and R in 1200..<2400):
    R += a

echo R