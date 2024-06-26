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

<<<<<<< HEAD
let 
=======
let
>>>>>>> c45928c6e371c2336e2de5e7e5ce54b785ed2739
  (N, M) = stdin.readLine.split.map(parseInt).toTuple(2)
  A = stdin.readLine.split.map(parseInt)
  C = stdin.readLine.split.map(parseInt)

<<<<<<< HEAD
var B = newSeq[int](M+1)
for i in 0..M:
  let w = min([i, N, M])
  # (d, e) == 畳み込みの図において重なる部分の配列
  # (A, B)に対応
  let dl = max(0, N-i)
  let dr = min(N, dl+i)
  let d = A[dl..dr].reversed()
  let e = B[M-i..M]
  # 
  let zz = zip(d[1 ..< ^0], e[1 ..< ^0])
  # echo zz
  let s = zz.mapIt(it[0]*it[1]).sum()
  let bb = (C[N+M-i] - s) div A[N]
  B[M-i] = bb

echo B.join(" ")
=======
>>>>>>> c45928c6e371c2336e2de5e7e5ce54b785ed2739
