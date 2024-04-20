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

# 書き換えて使う想定
const Modulo = 998244353
type ModInt = distinct int

proc toModInt(x: int): ModInt =
  ModInt( ((x mod Modulo) + Modulo) mod Modulo )

proc `$`(x: ModInt): string =
  $(x.int)

proc `+`(a, b: ModInt): ModInt =
  (a.int + b.int).toModInt
proc `+`(a: ModInt, b: int): ModInt =
  (a.int + b).toModInt
proc `+`(a: int, b: ModInt): ModInt =
  (a + b.int).toModInt
proc `-`(a, b: ModInt): ModInt =
  (a.int - b.int).toModInt
proc `-`(a: ModInt, b: int): ModInt =
  (a.int - b).toModInt
proc `-`(a: int, b: ModInt): ModInt =
  (a - b.int).toModInt
proc `*`(a, b: ModInt): ModInt =
  (a.int * b.int).toModInt
proc `*`(a: ModInt, b: int): ModInt =
  (a.int * b).toModInt
proc `*`(a: int, b: ModInt): ModInt =
  (a * b.int).toModInt

proc `+=`(a: var ModInt, b: int | ModInt): ModInt =
  a = a + b
proc `-=`(a: var ModInt, b: int | ModInt): ModInt =
  a = a - b
proc `*=`(a: var ModInt, b: int | ModInt): ModInt =
  a = a * b

################################

proc isOverrapped(a, b: (int, int)): bool =
  let (al, ar) = a
  return (b[0] in al..ar) or (b[1] in al..ar)
    
proc mergedRange(ranges: seq[(int, int)], v: (int, int)): seq[(int, int)] =
  var overrappedRanges = newSeq[(int, int)]()
  for r in ranges:
    if r.isOverrapped(v):
      overrappedRanges.add(r)
    else:
      result.add(r)
  var nums = newSeq[int]()
  if overrappedRanges.len > 0:
    overrappedRanges.add(v)
    for (l, r) in overrappedRanges:
      nums.add(l)
      nums.add(r)
    result.add((nums.min(), nums.max()))
  else:
    result.add(v)
let (B, C) = stdin.readLine.split.map(parseInt).toTuple(2)

# 引くだけ
var (al, ar) = (B - (C div 2), B)
if al > ar: swap(al, ar)
# 最初に*-1
var (bl, br) = (-B, -B - ((C-1) div 2))
if bl > br: swap(bl, br)
# 最後に*-1
var (cl, cr) = (-B, -(B - ((C-1) div 2)))
if cl > cr: swap(cl, cr)
# 最初と最後に*-1
var (dl, dr) = (B, -(-B - ((C-2) div 2)))
if dl > dr: swap(dl, dr)

var rangeList = newSeq[(int, int)]()
for r in [(al, ar), (bl, br), (cl, cr), (dl, dr)]:
  rangeList = rangeList.mergedRange(r)

# echo [(al, ar), (bl, br), (cl, cr), (dl, dr)]
# echo rangeList

var result = 0
for (l, r) in rangeList:
  result += (r-l)+1
echo result