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
  N = stdin.readLine.parseInt()
  TXA = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(3))

var timeTable = initTable[(int, int), int]()
for (t, x, a) in TXA:
  timeTable[(t, x)] = a
# dp: 時刻iでに座標jにいてとれる最大スコア
let lastTime = TXA[^1][0]
var dp = newSeqWith(lastTime+1, newSeqWith(5, -INF))
dp[0][0] = 0
for i in 1..lastTime:
  for j in 0..<5:
    var validBefores = [j-1, j, j+1].filterIt(it in 0..<5)
    # echo validBefores
    for b in validBefores:
      dp[i][j] = max(dp[i][j], dp[i-1][b])
    if timeTable.hasKey((i, j)):
      let size = timeTable[(i, j)]
      dp[i][j] += size

# echo dp
echo dp[lastTime].max()
