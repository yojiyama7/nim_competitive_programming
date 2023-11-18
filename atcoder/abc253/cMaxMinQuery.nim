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
  Q = stdin.readLine.parseInt()
  QUERY = newSeqWith(Q, stdin.readLine.split.map(parseInt))

var
  minHeap = initHeapQueue[int]()
  maxHeap = initHeapQueue[int]()
  countTable = initTable[int, int]()
for q in QUERY:
  case q[0]
  of 1:
    minHeap.push(q[1])
    maxHeap.push(-q[1])
    if q[1] notin countTable:
      countTable[q[1]] = 0
    countTable[q[1]] += 1
  of 2:
    if q[1] notin countTable:
      continue
    countTable[q[1]] = max(0, countTable[q[1]]-q[2])
  of 3:
    while countTable[minHeap[0]] == 0:
      discard minHeap.pop()
    while countTable[-maxHeap[0]] == 0:
      discard maxHeap.pop()
    echo -maxHeap[0] - minHeap[0]
  else: discard
  # echo (minHeap, maxHeap, countTable)