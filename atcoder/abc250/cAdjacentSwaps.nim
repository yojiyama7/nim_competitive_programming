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
  (N, Q) = stdin.readLine.split.map(parseInt).toTuple(2)
  X = newSeqWith(Q, stdin.readLine.parseInt())

var
  nums = (0..<N).toSeq()
  numToIdxs = (0..<N).toSeq()
for Xi in X:
  let
    x = Xi-1
    xIdx = numToIdxs[x]
    yIdx =  if xIdx == N-1:
              xIdx - 1
            else:
              xIdx + 1
    y = nums[yIdx]
  (
    nums[xIdx], nums[yIdx],
    numToIdxs[x], numToIdxs[y]
  ) = (
    nums[yIdx], nums[xIdx],
    numToIdxs[y], numToIdxs[x]
  )
  # echo nums

echo nums.mapIt(it+1).join(" ")
