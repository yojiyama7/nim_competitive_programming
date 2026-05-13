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

const INF = 1 shl 60

let
  (N, K) = stdin.readLine.split.map(parseInt).toTuple(2)
  H = stdin.readLine.split.map(parseInt)

var dp = newSeqWith(N+1, INF)
dp[1] = 0

## これが間に合うのnimって感じ
for i1 in 2..N:
  let i0 = i1-1
  for j in 1..K:
    if i1 - j >= 1:
      dp[i1] = min(
        dp[i1],
        dp[i1 - j] + abs(H[i0] - H[i0 - j])
      )

echo dp[N]
