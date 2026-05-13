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
  S = stdin.readLine
  T = stdin.readLine

## dp[i][j]: Sのi番目(1)までとTのj番目(1)までを部分問題として解いた時のスコア
var dp = newSeqWith(S.len()+1, newSeqWith(T.len()+1, 0))

for i1 in 1..S.len():
  for j1 in 1..T.len():
    dp[i1][j1] = max(
      dp[i1 - 1][j1],
      dp[i1][j1 - 1],
    )
    if S[i1-1] == T[j1-1]:
      dp[i1][j1] = max(dp[i1][j1],
        dp[i1 - 1][j1 - 1] + 1
      )

# let maxLen = dp[S.len()][T.len()]
# var result = '.'.repeat(maxLen)
# var (ci1, cj1) = (S.len(), T.len())
# for i1 in (1..maxLen).toSeq.reversed():
#   while dp[ci1 - 1][cj1] == dp[ci1][cj1]:
#     ci1 -= 1
#   while dp[ci1][cj1 - 1] == dp[ci1][cj1]:
#     cj1 -= 1
#   result[i1-1] = S[ci1-1]
#   ci1 -= 1
#   cj1 -= 1
# echo result

let maxLen = dp[S.len()][T.len()]
var result = '.'.repeat(maxLen)
var (s_bi, t_bj) = (S.len(), T.len())
for i1 in (1..maxLen).toSeq.reversed():
  while dp[s_bi - 1][t_bj] == dp[s_bi][t_bj]:
    s_bi -= 1
  while dp[s_bi][t_bj - 1] == dp[s_bi][t_bj]:
    t_bj -= 1
  result[i1-1] = S[s_bi-1]
  s_bi -= 1
  t_bj -= 1
echo result
