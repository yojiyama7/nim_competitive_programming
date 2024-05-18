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
  AB = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(2))

# 盤面x(xをN桁二進数として、1は使用済み0は使用していない)の操作する人が勝てるか
var memo = newSeqWith(2^N, -1)
proc solve(x: int): bool =
  if memo[x] != -1:
    return memo[x].bool
  var validIdxs = newSeq[int]()
  for i in 0..<N:
    if not x.testBit(i):
      validIdxs.add(i)
  if validIdxs.len < 2:
    memo[x] = 0; return false
  for i in 0 ..< validIdxs.len-1:
    let vi = validIdxs[i]
    for vj in validIdxs[i+1..^1]:
      let (a, b) = AB[vi]
      let (c, d) = AB[vj]
      if not (a == c or b == d):
        continue
      let n = (x or (1 shl vi) or (1 shl vj))
      if solve(n) == false:
        memo[x] = 1; return true
  memo[x] = 0; return false

let result = solve(0)
if result:
  echo "Takahashi"
else:
  echo "Aoki"
