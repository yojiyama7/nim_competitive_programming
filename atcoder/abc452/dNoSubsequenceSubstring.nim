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
  S = stdin.readLine()
  T = stdin.readLine()

# 終端がi番目で、Tのj番目までを丁度部分列に含むような連続部分列のパターン数
var dp = newSeqWith(S.len+1, newSeqWith(T.len+1, 0))
dp[0][0] = 1
for i in 1..S.len:
  dp[i][0] += 1
  if S[i-1] == T[0]:
    dp[i][1] += 1
  for j in 0..T.len:
    if j == T.len or S[i-1] != T[j]:
      dp[i][j] += dp[i-1][j]
    if j > 0 and S[i-1] == T[j-1]:
      dp[i][j] += dp[i-1][j-1]

for dpi in dp:
  echo dpi
echo S.len * (S.len + 1) div 2 - (0..S.len).mapIt(dp[it][T.len]).sum()

# うまく dp を設計できず
# var dp = newSeqWith(S.len+1, newSeqWith(T.len+1, 0))
# dp[0][0] = 1
# for i in 1..S.len:
#   for j in 0..T.len:
#     if j > 0 and S[i-1] == T[j-1]:
#       dp[i][j] = dp[i-1][j] + dp[i][j-1]
#     else:
#       dp[i][j] = dp[i-1][j] + 1
# for dpi in dp:
#   echo dpi
# echo dp[S.len][T.len]
# var score = 0
# for i in 0..S.len:
#   score += dp[i][T.len]
# echo score
