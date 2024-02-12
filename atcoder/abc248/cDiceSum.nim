import sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables
import complex, random, deques, heapqueue, sets, macros
{. warning[UnusedImport]: off, hint[XDeclaredButNotUsed]: off .}

template newSeqWith*(len: int, init: untyped): untyped =
  var result = newSeq[typeof(init, typeOfProc)](len)
  for i in 0 ..< len:
    result[i] = init
  move(result) # refs bug #7295

# since (1, 1):
template countIt*(s, pred: untyped): int =
  var result = 0
  for it {.inject.} in s:
    if pred: result += 1
  result

macro toTuple[T](a: openArray[T], n: static[int]): untyped =
  ## かなり原始的に書いている
  ## より短くはできるが見てわかりやすいように
  let tmp = genSym()
  let t = newNimNode(nnkPar)
  for i in 0..<n:
    t.add(
      newNimNode(nnkBracketExpr).add(
        tmp,
        newLit(i)
      )
    )
  result = newNimNode(nnkStmtListExpr).add(
    newNimNode(nnkLetSection).add(
      newNimNode(nnkIdentDefs).add(
        tmp,
        newNimNode(nnkEmpty),
        a
      )
    ),
    t
  )
  # echo result.treeRepr

proc just[T, U](x: T, f: T -> U): U =
  return x.f

################################

let (N, M, K) = stdin.readLine.split.map(parseInt).toTuple(3)
const MOD = 998244353

var dp: array[0..50, array[0..2500, int]]
for i in 0..2500:
  dp[0][i] = 1

# 長さaLenの数列において
# 全要素の和がaSumLimit以下である
# という条件を満たすパターン数
for aLen in 1..N:
  for aSumLimit in 1..K:
    for x in 1..M:
      if x <= aSumLimit:
        dp[aLen][aSumLimit] += dp[aLen-1][aSumLimit-x]
        dp[aLen][aSumLimit] = dp[aLen][aSumLimit] mod MOD

# for line in dp[0..N]:
#   echo line[0..K]
echo dp[N][K]
