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

proc `..<^`(a, b: int): HSlice[int, BackwardsIndex] =
  return a ..< ^b

let 
  (N, M, K) = stdin.readLine.split.map(parseInt).toTuple(3)
  rawCAR = newSeqWith(M, stdin.readLine.split.toSeq)
var C = newSeq[int](M)
var A = newSeq[seq[int]](M)
var R = newSeq[char](M)
for i, car in rawCAR:
  C[i] = car[0].parseInt()
  A[i] = car[1..<^1].map(parseInt)
  R[i] = car[^1][0]

var result = 0
for i in 0..<(1 shl N):
  block solve:
    for (a, r) in zip(A, R):
      var validKeyNum = 0
      for aj1 in a:
        if i.testBit(aj1-1): validKeyNum += 1
      # echo (i, validKeyNum)
      if (validKeyNum >= K) xor (r == 'o'):
        break solve
    result += 1

echo result
