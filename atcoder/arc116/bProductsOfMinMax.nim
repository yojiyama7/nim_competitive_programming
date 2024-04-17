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
var
  A = stdin.readLine.split.map(parseInt)

A.sort()

# 最後は番兵
var b = newSeq[int](N+1)
for i in countdown(N-1, 0):
  b[i] = (A[i] + b[i+1]*2) mod MOD

# echo A
# echo b

var result = 0
for i in 0..<N:
  # echo (A[i], b[i+1])
  let score = (((A[i]+b[i+1]) mod MOD) * A[i]) mod MOD
  # echo score
  result = (result + score) mod MOD

echo result