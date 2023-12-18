import std/[sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables, complex, random, deques, heapqueue, sets, macros]
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

################################

proc maxv(a: var int, b: int): void =
  if a < b:
    a = b

let
  N = stdin.readLine.parseInt()
  XY = newseqwith(N, stdin.readLine.split.map(parseInt).toTuple(2))

# dp[i][j]: i番目(1idx)までで腹の状態jでの最大スコア
var dp = newSeqWith(N+1, newSeqWith(2, 0))
for i in 0..<N: #配る
  let (x, y) = XY[i]
  # 食べない
  dp[i+1][0].maxv(dp[i][0])
  dp[i+1][1].maxv(dp[i][1])
  if x == 0:
    # 解毒
    dp[i+1][0].maxv(dp[i][0] + y)
    dp[i+1][0].maxv(dp[i][1] + y)
  else:
    # 毒
    dp[i+1][1].maxv(dp[i][0] + y)

echo dp[N].max()
