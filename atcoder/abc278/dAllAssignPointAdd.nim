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
  N = stdin.readLine.parseInt()
var
  A = stdin.readLine.split.map(parseInt)
let 
  Q = stdin.readLine.parseInt()
  QUERY = newSeqWith(Q, stdin.readLine.split.map(parseInt))

var
  resetCnt = 0
  lastResetNum = -1
  resetedIdxs = newSeqWith(N, 0)

for query in QUERY:
  case query[0]:
  of 1:
    let x = query[1]
    resetCnt += 1
    lastResetNum = x
  of 2:
    let (i, x) = (query[1]-1, query[2])
    if resetedIdxs[i] != resetCnt:
      A[i] = lastResetNum
      resetedIdxs[i] = resetCnt
    A[i] += x
  of 3:
    let i = query[1]-1
    if resetedIdxs[i] != resetCnt:
      A[i] = lastResetNum
      resetedIdxs[i] = resetCnt
    echo A[i]
  else: discard
