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
  (N, L) = stdin.readline.split.map(parseInt).toTuple(2)
  D = stdin.readline.split.map(parseInt)

if L mod 3 != 0:
  echo 0
  quit()

var points = @[0].toCountTable()
var cur = 0
for d in D:
  cur = (cur + d) mod L
  points.inc(cur)

# echo points

var result = 0
for a in 0..<L:
  let b = (a + (L div 3)) mod L
  let c = (b + (L div 3)) mod L
  # echo (a, b, c)
  if not ((a in points) and (b in points) and (c in points)):
    continue
  result += points[a] * points[b] * points[c]

echo result div 3
