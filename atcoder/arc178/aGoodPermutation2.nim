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

# N以上のAiがあるときは-1
# >>> Aiが全てN未満であるとする
# Aiが1だと？ -> 1が存在するので不可能
# >>> 1 < Ai < N であるとする
# 1は最初におきたいし、最初における
# 前から貪欲で良さげ？

let 
  (N, M) = stdin.readLine.split.map(parseInt).toTuple(2)
  A = stdin.readLine.split.map(parseInt)

if not (1 < A.min() and A.max() < N):
  echo -1
  quit()

let setA = A.toHashSet()

var result = (1..N).toSeq()
for i1 in 1..N:
  if i1 in setA:
    swap(result[i1-1], result[i1])

echo result.join(" ")