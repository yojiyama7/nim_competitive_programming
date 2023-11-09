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

let
  Q = stdin.readLine.parseInt()
  QUERY = newSeqWith(Q, stdin.readLine.split.map(parseInt))

var q = initDeque[tuple[num, cnt: int]](Q.nextPowerOfTwo())
for query in QUERY:
  if query[0] == 1:
    # echo query[1 ..< ^0]
    let (x, c) = query[1 ..< ^0].toTuple(2)
    q.addLast( (x, c) )
  elif query[0] == 2:
    var c = query[1]
    var sumNum = 0
    while c > 0:
      var first = q.popFirst()
      let z = min(c, first.cnt)
      c -= z
      sumNum += first.num * z
      first.cnt -= z
      if first.cnt > 0:
        q.addFirst(first)
    echo sumNum
