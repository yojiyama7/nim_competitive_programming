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

let pins = stdin.readLine.mapIt((it.int - '0'.int) == 1)

const colIdxsList = @[@[6,], @[3,], @[7, 1], @[4, 0], @[8, 2], @[5,], @[9,]]

proc solve(): string =
  if pins[0] == true:
    return "No"
  var hasColPinList = newSeq[bool](colIdxsList.len)
  for i, colIdxs in colIdxsList:
    hasColPinList[i] = colIdxs.anyIt(pins[it] == true)

  var reqSplit = @[true, false, true]
  for hasColPin in hasColPinList:
    if reqSplit.len == 0:
      break
    if hasColPin == reqSplit[^1]:
      discard reqSplit.pop()
  if reqSplit.len == 0:
    return "Yes"
  else:
    return "No"

echo solve()
