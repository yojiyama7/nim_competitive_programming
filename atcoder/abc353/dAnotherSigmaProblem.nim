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

const MOD = 998244353
let 
  N = stdin.readLine.parseInt()
  A = stdin.readLine.split.map(parseInt)

proc calcDigitNum(x: int): int =
  ($x).len

var accByDegitNum = newSeqWith(11, newSeqWith(N+1, 0))
for i1 in 1..N:
  let degitNum = calcDigitNum(A[i1-1])
  for x in 1..10:
    accByDegitNum[x][i1] = accByDegitNum[x][i1 - 1]
    if x == degitNum:
      accByDegitNum[x][i1] += 1
var accA = newSeq[int](N+1)
for i in 0..<N:
  accA[i+1] = (accA[i] + A[i]).euclMod MOD

var result = 0
for i, a in A:
  let (l, r) = (i+1, N)
  var score = 0
  for x in 1..10:
    let s = ((a.euclMod(MOD) * (10^x).euclMod(MOD)).euclMod(MOD) * (accByDegitNum[x][r] - accByDegitNum[x][l])).euclMod(MOD)
    score = score + s.euclMod(MOD)
  let s = accA[r] - accA[l]
  score = (score + s).euclMod MOD
  result = (result + score).euclMod MOD

echo result