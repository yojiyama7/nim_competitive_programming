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

const INF = 1 shl 60
let 
  N = stdin.readLine.parseInt()
  A = stdin.readLine.split.map(parseInt)

# 0番を食べる。i番目までの動物をi番の餌を[食べずに, 食べて][j]餌付け完了している
var dp1 = newSeqWith(N, newSeqWith(2, INF))
dp1[0][1] = A[0]
for i in 1..<N:
  # A[i]を食わない
  dp1[i][0] = min([
    dp1[i][0],
    dp1[i-1][1],
  ])
  # A[i]を食う
  dp1[i][1] = min([
    dp1[i][1],
    dp1[i-1][1] + A[i],
    dp1[i-1][0] + A[i],
  ])

# 0番は食べない。他はdp1と同じ
var dp2 = newSeqWith(N, newSeqWith(2, INF))
dp2[0][0] = 0
for i in 1..<N:
  dp2[i][0] = min([
    dp2[i][0],
    dp2[i-1][1],
  ])
  dp2[i][1] = min([
    dp2[i][1],
    dp2[i-1][1] + A[i],
    dp2[i-1][0] + A[i],
  ])

let cands = [dp1[N-1][0], dp1[N-1][1], dp2[N-1][1]]
# echo cands
# echo dp2
let result = min(cands)
echo result
