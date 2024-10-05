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

let 
  N = stdin.readLine.parseInt()
  P = stdin.readLine.split.map(parseInt)

# i番目まででj個選んだ時のScore(0.9^i * A[i] の合計(後ろから))最大値
var dp = newSeqWith(N+1, newSeqWith(N+1, -Inf))
dp[0][0] = 0
for i in 1..N:
  for j in 0..i: # off-by-one エラーに気をつけろ
    # 新しく選ぶときは元のscore を 0.9倍して ぱふぉを足す
    if j != i:
      dp[i][j] = dp[i-1][j]
    if j-1 >= 0:
      dp[i][j] = max(
        dp[i][j],
        dp[i-1][j-1]*0.9 + P[i-1].float
      )
# echo dp

var result = -Inf
for i in 1..N:
  let a = dp[N][i] / (0..<i).mapIt(0.9^it).sum()
  let b = 1200 / i.float.sqrt()
  let r = a - b
  # echo (a, b, r)
  result = max(result, r)

echo result
