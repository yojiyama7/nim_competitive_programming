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
  (N, X) = stdin.readLine.split.map(parseInt).toTuple(2)
  AB = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(2))

# dp: i種類目(1)までの硬貨をつかって、j円が払えるかどうか(bool)
var dp = newSeqWith(N+1, newSeqWith(X+1, false))
dp[0][0] = true
for i1 in 1..N:
  let (a, b) = AB[i1-1]
  for j in 0..X:
    if j == 0: dp[i1][0] = true; continue
    for cnt in 0..b:
      let remain = j - a*cnt
      if remain >= 0 and dp[i1 - 1][remain]:
        dp[i1][j] = true

# echo dp

if dp[N][X]:
  echo "Yes"
else:
  echo "No"
