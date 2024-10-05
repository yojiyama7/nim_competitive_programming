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
  N = stdin.readLine.parseInt()
  XY = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(2))

proc calcNeighbor(p: (int, int)): seq[(int, int)] =
  let (x, y) = p
  for (dx, dy) in [(-1, -1), (-1, 0), (0, -1), (0, 1), (1, 0), (1, 1)]:
    result.add((x+dx, y+dy))

let setXY = XY.toHashSet()

var result = 0
var visited = initHashSet[(int, int)]()
for p in XY:
  if p in visited:
    continue 
  visited.incl(p)
  var s = @[p]
  while s.len > 0:
    let t = s.pop()
    for c in calcNeighbor(t):
      if c notin setXY:
        continue
      if c in visited:
        continue
      visited.incl(c)
      s.add(c)
  result += 1

echo result