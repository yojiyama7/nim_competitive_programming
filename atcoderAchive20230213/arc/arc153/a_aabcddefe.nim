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

let N = stdin.readLine.parseInt()

# a  b c d  e  f
# 12 3 4 56 79 8

proc parseDigits(x: int): seq[int] =
  var n = x
  while n > 0:
    result.add(n mod 10)
    n = n div 10
  result

proc UnparseFromDigits(nums: openArray[int]): int =
  for x in nums:
    result *= 10
    result += x
  result

var beautifulNums = newSeq[int]()
for i in 100000..999999:
  let (f, e, d, c, b, a) = parseDigits(i).toTuple(6)
  let bNum = UnparseFromDigits([a, a, b, c, d, d, e, f, e])
  beautifulNums.add(bNum)

echo beautifulNums[N-1]
