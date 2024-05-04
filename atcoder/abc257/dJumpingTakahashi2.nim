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
  XYP = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(3))

proc isValid(sss: int): bool =
  for si, start in XYP:
    var isVisited = newSeqWith(N, false)
    isVisited[si] = true
    var posList = @[start]
    while posList.len > 0:
      # echo (posList, isVisited)
      let (tx, ty, tp) = posList.pop()
      for i, (x, y, p) in XYP:
        if isVisited[i]:
          continue
        if abs(x-tx) + abs(y-ty) > tp*sss:
          continue
        isVisited[i] = true
        posList.add((x, y, p))
    # echo isVisited
    if isVisited.allIt(it):
      return true
  return false

var (ng, ok) = (-1, 4*10^9)
while abs(ok-ng) > 1:
  let mid = (ok + ng) div 2
  if isValid(mid):
    ok = mid
  else:
    ng = mid

echo ok