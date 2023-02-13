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

let
  (N, K) = stdin.readLine.split.map(parseInt).toTuple(2)
  A = stdin.readLine.split.map(parseInt)
  B = stdin.readLine.split.map(parseInt)

let AB = zip(A, B)

var dp = newSeqWith(N, @[false, false])
dp[0] = @[true, true]
for i in 1..<N:
  if dp[i-1][0] and abs(A[i-1]-AB[i][0]) <= K:
    dp[i][0] = true
  if dp[i-1][1] and abs(B[i-1]-AB[i][0]) <= K:
    dp[i][0] = true
  if dp[i-1][0] and abs(A[i-1]-AB[i][1]) <= K:
    dp[i][1] = true
  if dp[i-1][1] and abs(B[i-1]-AB[i][1]) <= K:
    dp[i][1] = true

if dp[N-1][0] or dp[N-1][1]:
  echo "Yes"
else:
  echo "No"

