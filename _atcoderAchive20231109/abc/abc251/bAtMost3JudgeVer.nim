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

let
  (N, W) = stdin.readLine.split.map(parseInt).toTuple(2)
  A = stdin.readLine.split.map(parseInt)

var flags = newSeqWith(W+1, false)
for i in 0..<N:
  let a = A[i]
  if a > W: continue
  flags[a] = true
  for j in i+1..<N:
    let b = A[j]
    if a + b > W: continue
    flags[a + b] = true
    for k in j+1..<N:
      let c = A[k]
      if a + b + c > W: continue
      flags[a + b + c] = true

echo flags.countIt(it)

# var dp = newSeqWith(N+1, newSeqWith(W+1, newSeqWith(4, false)))
# dp[0][0][0..3] = [true, true, true, true]

# for i in 1..N:
#   for j in 0..W:
#     for k in 0..3:
#       if k >= 1 and j-A[i-1] >= 0:
#         dp[i][j][k] = dp[i-1][j][k] or dp[i-1][j-A[i-1]][k-1]
#       else:
#         dp[i][j][k] = dp[i-1][j][k]

# # for i, dpi in dp:
# #   for j, dpij in dpi:
# #     echo (i, j), dpij.mapIt(($it)[0]).join()

# echo dp[N][1..W].countIt(true in it)
