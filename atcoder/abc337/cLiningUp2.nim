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
  N = stdin.readLine.parseInt()
  A1 = stdin.readLine.split.map(parseInt)

# 矢印を逆向きにして　次の人を参照できるようにする
var l = newSeqWith(N, -1)
var idx = -1
for i, a1 in A1:
  if a1 == -1: # 先頭の人を記録
    idx = i
    continue
  l[a1-1] = i

var result = newSeq[int]()
while idx != -1:
  result.add(idx+1)
  idx = l[idx]

echo result.join(" ")