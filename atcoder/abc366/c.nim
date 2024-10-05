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

let
  Q = stdin.readLine.parseInt()
  QUERY = newSeqWith(Q, stdin.readLine.split.map(parseInt))

var t = initTable[int, int]()
for query in QUERY:
  case query[0]
  of 1:
    let x = query[1]
    if not t.hasKey(x):
      t[x] = 0
    t[x] += 1
  of 2:
    let x = query[1]
    t[x] -= 1
    if t[x] == 0:
      t.del(x)
  of 3:
    # echo t
    echo t.len()
  else: discard

