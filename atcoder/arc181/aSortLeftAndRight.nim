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

################################

let T = stdin.readLine.parseInt()

proc solve(N: int, P: seq[int]): int =
  if P.isSorted():
    return 0

  let ans = P.sorted()
  var t = initTable[int, int]()
  for (a, p) in zip(ans, P):
    if not t.hasKey(p):
      t[p] = 0
    t[p] += 1
    if not t.hasKey(a):
      t[a] = 0
    t[a] -= 1
  echo 2

for _ in 0..<T:
  let N = stdin.readLine.parseInt()
  let P = stdin.readLine.split.map(parseInt)

  echo solve(N, P)
