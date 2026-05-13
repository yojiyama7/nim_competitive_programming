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

let INF = 1 shl 60

let
  (N, W) = stdin.readLine.split.map(parseInt).toTuple(2)
  wvList = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(2))

let vSum = wvList.mapIt(it[1]).sum()
## dp[i][j]: i番目(1)までの商品で価値j以上となるパターンの内重さが最小のもの
var dp = newSeqWith(N+1, newSeqWith(vSum+1, INF))
dp[0][0] = 0
##
for i1 in 1..N:
  let (w, v) = wvList[i1-1]
  for j in (0..vSum).toSeq.reversed():
    dp[i1][j] = dp[i1-1][j]
    if j + 1 <= vSum:
      dp[i1][j] = min(dp[i1][j],
        dp[i1][j + 1]
      )
    if j - v >= 0:
      dp[i1][j] = min(dp[i1][j],
        dp[i1 - 1][j - v] + w
      )

echo dp[N].upperBound(W) - 1