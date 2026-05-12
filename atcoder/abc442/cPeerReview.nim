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
  (N, M) = stdin.readLine.split.map(parseInt).toTuple(2)
  A1B1 = newSeqWith(M, stdin.readLine.split.map(parseInt).toTuple(2))

var invalid_reviewers  = newSeqWith(N, 1)
for (a1, b1) in A1B1:
  let (a, b) = (a1-1, b1-1)
  invalid_reviewers[a] += 1
  invalid_reviewers[b] += 1

var res = newSeqWith(N, -1)
for i in 0..<N:
  let x = N - invalid_reviewers[i]
  res[i] = x * (x-1) * (x-2) div 6

echo res.join(" ")
