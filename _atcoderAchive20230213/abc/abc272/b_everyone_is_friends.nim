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
  (N, M) = stdin.readLine.split.map(parseInt).toTuple(2)
  X = newSeqWith(M, stdin.readLine.split.map(parseInt)[1..^1])

var isFriend = newSeqWith(N, newSeq[bool](N))
for x in X:
  # もっと書きようがありそう product がタプルを受け取ったときはタプルを返すとか？
  for ab in product([x, x]):
      var (a, b) = ab.toTuple(2)
      a -= 1
      b -= 1
      isFriend[a][b] = true
      isFriend[b][a] = true

if isFriend.foldl(a & b).allIt(it):
  echo "Yes"
else:
  echo "No"