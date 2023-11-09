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

{.checks:off.}

let
  (H, W) = stdin.readLine.split.map(parseInt).toTuple(2)
  S = newSeqWith(H, stdin.readLine)
  T = newSeqWith(H, stdin.readLine)
# let
#   (H, W) = (632, 632)
#   S = (0..<H).mapIt(".".repeat(it) & "#".repeat(W-it))
#   T = (0..<H).mapIt(".".repeat(it) & "#".repeat(W-it))

var revS = newSeq[string]()
for i in 0..<W:
  revS.add(S.mapIt(it[i]).join())
var revT = newSeq[string]()
for i in 0..<W:
  revT.add(T.mapIt(it[i]).join())

if revS.toCountTable == revT.toCountTable:
  echo "Yes"
else:
  echo "No"
