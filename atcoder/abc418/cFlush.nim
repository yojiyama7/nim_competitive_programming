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
  (N, Q) = stdin.readLine.split.map(parseInt).toTuple(2)
  A = stdin.readLine.split.map(parseInt)
  B = newSeqWith(Q, stdin.readLine.parseInt())

let sumA = A.sum()
var numsA = newSeq[int](A.max()+1)
for a in A:
  numsA[a] += 1
# echo numsA
var l = newSeq[int](A.max()+1)
l[^1] = 0
for i in (0..<numsA.len()-1).toSeq.reversed():
  l[i] += l[i+1] + numsA[i+1]
# echo l

var accl = newSeq[int](l.len() + 1)
for i in 0..<l.len():
  accl[i+1] = accl[i] + l[i]

for b in B:
  if b < l.len():
    # echo l[0..<b-1].sum() + 1
    echo accl[b-1] + 1
  else:
    echo -1

