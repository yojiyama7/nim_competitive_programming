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
  (H, W, C, Q) = stdin.readLine.split.map(parseInt).toTuple(4)
  TNC = newSeqWith(Q, stdin.readLine.split.map(parseInt).toTuple(3))

var
  rCnt = 0
  cCnt = 0
  rows = initHashSet[int]()
  cols = initHashSet[int]()
  cntsByColor = newSeqWith(C, 0)
for (t, n1, c1) in TNC.reversed:
  let (n, c) = (n1-1, c1-1)
  case t:
  of 1:
    if n in rows:
      continue
    cntsByColor[c] += W - cCnt
    rows.incl(n)
    rCnt += 1
  of 2:
    if n in cols:
      continue
    cntsByColor[c] += H - rCnt
    cols.incl(n)
    cCnt += 1
  else: discard

echo cntsByColor.join(" ")
