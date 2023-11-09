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

let (H, M) = stdin.readLine.split.map(parseInt).toTuple(2)

proc isEasyToMisjudge(timeMin: int): bool =
  let (h, m) = (timeMin div 60, timeMin mod 60)
  # echo [h, m]
  let (a, b, c, d) = (h div 10, h mod 10, m div 10, m mod 10)
  let (anotherH, anotherM) = (a*10+c, b*10+d)
  anotherH in 0..<24 and anotherM in 0..<60

var timeMin = H*60+M
while not timeMin.isEasyToMisjudge:
  timeMin = (timeMin+1) mod (60*24)
let (resH, resM) = (timeMin div 60, timeMin mod 60 )
echo [resH, resM].join(" ")
