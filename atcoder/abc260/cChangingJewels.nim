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

# red(n) = red(n-1) + blue(n)*X
# blue(n) = red(n-1) + blue(n-1)*Y
# red(n) = red(n-1) + red(n-1)*X + blue(n-1)*Y*X
#        = red(n-1)*(1+X) + blue(n-1)*(X*Y)
# red(n) * cnt = (red(n-1)*(1+X) + blue(n-1)*(X*Y))*cnt
# red(n)*cnt = red(n-1)*(1+X)*cnt + blue(n-1)*(X*Y)*cnt

let (N, X, Y) = stdin.readLine.split.map(parseInt).toTuple(3)

var
  level = N
  red = 1
  blue = 0

while level >= 2:
  var nRed, nBlue = 0
  # 操作1
  nRed += 1*red
  blue += X*red
  # 操作2
  nRed += 1*blue
  nBlue += Y*blue
  (red, blue) = (nRed, nBlue)
  level -= 1

echo blue
