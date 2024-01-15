import sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables
import complex, random, deques, heapqueue, sets, macros
{. warning[UnusedImport]: off, hint[XDeclaredButNotUsed]: off, hint[Name]: off .}

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
# since (1, 1):
func maxIndex*[T](s: openArray[T]): int =
  for i in 1..high(s):
    if s[i] > s[result]: result = i

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

let 
  (N, M) = stdin.readLine.split.map(parseInt).toTuple(2)
  X = stdin.readLine.split.map(parseInt)
  CY = newSeqWith(M, stdin.readLine.split.map(parseInt).toTuple(2))

let bonus = CY.toTable()
# dp[i][j]: i回目のトスでカウンタがjである時の最大スコア
var dp = newSeqWith(N+1, newSeqWith(N+1, 0))
dp[0][0] = 0
for i in 0..<N:
  for j in 0..i:
    dp[i+1][j+1] = max(
      dp[i+1][j+1],
      dp[i][j] + X[i] + (if j+1 in bonus: bonus[j+1] else: 0)
    )
    dp[i+1][0] = max(
      dp[i+1][0],
      dp[i][j]
    )
# for dpi in dp: echo dpi
echo dp[N].max()
