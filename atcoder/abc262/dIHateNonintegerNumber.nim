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

const MOD = 998244353
let
  N = stdin.readLine.parseInt
  A = stdin.readLine.split.map(parseInt)

var result = 0
for i in 1..N:
  # 0..<j 番目でk個選んで合計がmod i でlになるパターン数
  var dp = newSeqWith(N+1, newSeqWith(i+1, newSeq[int](i)))
  dp[0][0][0] = 1
  for j in 0..<N:
    for k in 0..i:
      for l in 0..<i:
        dp[j+1][k][l] += dp[j][k][l]
        dp[j+1][k][l] = dp[j+1][k][l] mod MOD
        if k < i:
          dp[j+1][k+1][(l+(A[j] mod i)) mod i] += dp[j][k][l]
          dp[j+1][k+1][(l+(A[j] mod i)) mod i] = dp[j+1][k+1][(l+(A[j] mod i)) mod i] mod MOD
  result += dp[N][i][0]
  result = result mod MOD

echo result
