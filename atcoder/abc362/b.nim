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
  (XA, YA) = stdin.readLine.split.map(parseInt).toTuple(2)
  (XB, YB) = stdin.readLine.split.map(parseInt).toTuple(2)
  (XC, YC) = stdin.readLine.split.map(parseInt).toTuple(2)

var abc = @[
  (XA-XB)^2 + (YA-YB)^2,
  (XB-XC)^2 + (YB-YC)^2,
  (XC-XA)^2 + (YC-YA)^2,
]
abc.sort()
let (a, b, c) = abc.toTuple(3)
if a + b == c:
  echo "Yes"
else:
  echo "No"