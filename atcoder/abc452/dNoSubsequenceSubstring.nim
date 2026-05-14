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

var dp = newSeqWith(S.len+1, newSeqWith(T.len+1, 0))
# dp[0][0] = 1
for i in 1..S.len:
  for j in 0..T.len:
    # 開始するが、matchはせず
    if j == 0 and S[i-1] != T[0]:
      dp[i][j] += 1
    # 開始して、即match
    if j == 1 and S[i-1] == T[0]:
      dp[i][j] += 1
    # すでに開始済で、matchせずただ追加
    if j == T.len or S[i-1] != T[j]:
      dp[i][j] += dp[i-1][j]
    # すでに開始済で、matchする
    if j > 0 and S[i-1] == T[j-1]:
      dp[i][j] += dp[i-1][j-1]

echo (0..S.len).mapIt(dp[it][0..<T.len].sum()).sum()
