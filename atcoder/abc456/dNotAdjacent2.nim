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
let S = stdin.readLine()

var dp = newSeqWith(S.len+1, array['a'..'z', int].default)
var dp_sum = newSeqWith(S.len+1, 0)
dp[1][S[0]] = 1
dp_sum[1] = 1
for i1 in 2..S.len:
  for c in 'a'..'z':
    dp[i1][c] = dp[i1-1][c]
    if c == S[i1-1]:
      dp[i1][c] = (dp[i1][c] + (dp_sum[i1-1] - dp[i1-1][c]) mod MOD) mod MOD
      dp[i1][c] = (dp[i1][c] + 1) mod MOD
  for x in dp[i1]:
    dp_sum[i1] = (dp_sum[i1] + x) mod MOD

# echo dp
# echo dp_sum
echo dp_sum[S.len]

