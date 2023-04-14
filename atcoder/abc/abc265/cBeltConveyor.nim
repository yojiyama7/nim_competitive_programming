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
  (H, W) = stdin.readLine.split.map(parseInt).toTuple(2)
  G = newSeqWith(H, stdin.readLine)

proc solve(): string =
  var
    (x, y) = (0, 0)
    isVisited = initHashSet[(int, int)]()
  isVisited.incl((0, 0))
  while true:
    let c = G[y][x]
    if c == 'U' and y != 0:
      y -= 1
    elif c == 'D' and y != H-1:
      y += 1
    elif c == 'L' and x != 0:
      x -= 1
    elif c == 'R' and x != W-1:
      x += 1
    else:
      break
    if (x, y) in isVisited:
      return "-1"
    isVisited.incl((x, y))
  return &"{y+1} {x+1}"

echo solve()
