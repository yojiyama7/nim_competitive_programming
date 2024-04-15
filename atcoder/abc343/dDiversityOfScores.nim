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
  (N, T) = stdin.readLine.split.map(parseInt).toTuple(2)
  AB = newSeqWith(T, stdin.readLine.split.map(parseInt).toTuple(2))

var 
  scores = newSeq[int](N)
  ct = [(0, N)].toTable()
for (a1, b) in AB:
  let before = scores[a1-1]
  scores[a1-1] += b
  let after = scores[a1-1]
  ct[before] -= 1
  if ct[before] == 1:
    ct.del(before)
  if not ct.hasKey(after):
    ct[after] = 0
  ct[after] += 1
  echo ct.len
