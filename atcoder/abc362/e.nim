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
  N = stdin.readLine.parseInt()
  A = stdin.readLine.split.map(parseInt)

# 終わり2項がai, bi
var memo = newSeqWith(N+1, newSeqWith(N+1, newSeqWith(N+1, -1)))
proc solve(a1, b1, l: int): int =
  if l == 2:
    if a1 < b1: return 1
    else:       return 0
  if memo[a1][b1][l] != -1:
    return memo[a1][b1][l]
  let (av, bv) = (A[a1-1], A[b1-1])
  for x1 in 1..<a1:
    let xv = A[x1-1]
    if av - xv == bv - av:
      result += solve(x1, a1, l-1)
      result = result mod MOD
  memo[a1][b1][l] = result
  return memo[a1][b1][l]

var result = @[N]
for l in 2..N:
  var res = 0
  for i1 in 1..N:
    for j1 in i1+1..N:
      res += solve(i1, j1, l)
      res = (res mod MOD)
  result.add(res)

echo result.join(" ")

################################

# const MOD = 998244353
# let 
#   N = stdin.readLine.parseInt()
#   A = stdin.readLine.split.map(parseInt)

# # i番目までの要素で [A[j], A[k]] を最初の2項とする長さlのパターン数
# var dp = newSeqWith(N+1, newSeqWith(N+1, newSeqWith(N+1, newSeqWith(N+1, 0))))
# # 長さ2について
# for k1 in 1..N:
#   for j1 in 1..<k1:
#     dp[k1][j1][k1][2] += 1
#     dp[k1][j1][k1][2] += dp[k1 - 1][j1][k1][2]
#     dp[k1][j1][k1][2] = dp[k1][j1][k1][2] mod MOD

# # 長さ3以上について
# for i1 in 3..N:
#   for j1 in 1..i1:
#     for k1 in j1+1..i1:
#       let d = A[k1-1] - A[j1-1]
#       for l in 3..i1:
#         # i番目を選ぶ
#         if A[j1-1] + d*(l-1) == A[i1-1]:
#           dp[i1][j1][k1][l] = (dp[i1][j1][k1][l] + dp[i1 - 1][j1][k1][l-1]) mod MOD
#         # i番目を選ばない　
#         dp[i1][j1][k1][l] = (dp[i1][j1][k1][l] + dp[i1 - 1][j1][k1][l]) mod MOD

# echo dp[3]

# var result = newSeqWith(N+1, 0)
# result[1] = N
# for i in 2..N:
#   for j1 in 1..N:
#     for k1 in j1+1..N:
#       result[i] += dp[N][j1][k1][2]
# echo result[1..^1].join(" ")

################################

# const MOD = 998244353
# let 
#   N = stdin.readLine.parseInt()
#   A = stdin.readLine.split.map(parseInt)

# # i(1)番目までで、最終項がx(x==-1:選んでいない)で、長さkで、公差dであるような等差数列の個数
# var memo = initTable[(int, int, int), Table[int, int]]()
# proc solve(i1, x, k, d: int): int =
#   if i1 < k:
#     return 0
#   if i1 == 0:
#     return 1
#   if x == -1:
#     return 1
#   if k == 0:
#     return 1
#   if memo.hasKey((i1, x, k)) and memo[(i1, x, k)].haskey(d):
#     return memo[(i1, x, k)][d]
#   # i(1)番目を選ぶ
#   if A[i1-1] == x:
#     result += solve(i1 - 1, x - d, k - 1, d)
#     result = result mod MOD
#   # i(1)を選ばない
#   result += solve(i1 - 1, x, k, d)
#   result = result mod MOD
#   memo[(i1, x, k)][d] = result
#   return memo[(i1, x, k)][d]

# var candOfDiffs = initHashSet[int]()
# for i in 0..<N:
#   for j in i+1..<N:
#     candOfDiffs.incl(A[j] - A[i])

# var result = newSeq[int]()
# for i in 1..N:
#   var score = 0
#   for a in A.toHashSet():
#     for diff in candOfDiffs:
#       echo (N, a, i, diff)
#       score += solve(N, a, i, diff)
#       score = score mod MOD
#   result.add(score)
# echo result.join(" ")

################################

# const MOD = 998244353
# let 
#   N = stdin.readLine.parseInt()
#   A = stdin.readLine.split.map(parseInt)

# var memo = newSeqWith(N+1, newSeqWith(N+1, initTable[int, int]()))
# # i(1)番目まででできる最終項がAのj(1)番目で公差がkであるような数列の個数(modded)
# proc solve(i1, j1, k: int): int =
#   if i1 == 0:
#     return 1
#   if memo[i1][j1].hasKey(k):
#     return memo[i1][j1][k]
#   if i1 == j1:
#     # i番目を選ぶ
#     for ltj1 in 1..<j1:
#       result += solve(i1-1, ltj1, k)
#   else:
#     # i番目を選ばない
#     result = solve(i1-1, j1, k)
#   memo[i1][j1][k] = result
#   return memo[i1][j1][k]

# var candOfDiffs = @[0]
# for i in 0..<N:
#   for j in 0..<N:
#     candOfDiffs.add(A[j]-A[i])

# var result = 0
# for i in 1..N:
#   for k in candOfDiffs:
#     result += solve(N, i, k)
# echo result  
