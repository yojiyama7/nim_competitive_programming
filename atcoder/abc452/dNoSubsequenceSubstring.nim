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

### Sのi文字目(1-idx)までで、Tの文字目(1-idx)までを構成するパターン数
var dp = newSeqWith(S.len+1, newSeqWith(T.len + 1, 0))
dp[0][0] = 1
for i1 in 1..S.len:
  for j1 in 1..T.len:
    dp[i1][j1] += dp[i1 - 1][j1]
    if S[i1-1] == T[j1-1]:
      dp[i1][j1] += dp[i1][j1 - 1]

echo dp[S.len][T.len]