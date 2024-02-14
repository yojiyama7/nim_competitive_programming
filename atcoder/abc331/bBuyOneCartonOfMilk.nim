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

let (N, S, M, L) = stdin.readLine.split.map(parseInt).toTuple(4)

let costOf48 = min([S*8, M*6, L*4])

var minCost = 1 shl 60
for si in 0..<8:
  for mi in 0..<6:
    for li in 0..<4:
      let num = si*6 + mi*8 + li*12
      let subCost = si*S + mi*M + li*L
      let mainCost = max(N-num, 0).ceilDiv(48) * costOf48
      let cost = mainCost + subCost
      if cost < minCost:
        minCost = cost
echo minCost
