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
  Q = stdin.readLine.parseInt()
  QUERY = newSeqWith(Q, stdin.readLine.split.map(parseInt))

var d = initDeque[(int, int)]()
for query in QUERY:
  if query[0] == 1:
    d.addLast((query[1], query[2]))
  elif query[0] == 2:
    var remain = query[1]
    var score = 0
    while remain > 0 and remain >= d[0][0]:
      remain -= d[0][0]
      score += d[0][0] * d[0][1]
      d.popFirst()
    if remain > 0:
      d[0][0] -= remain
      score += remain * d[0][1]
    echo score
