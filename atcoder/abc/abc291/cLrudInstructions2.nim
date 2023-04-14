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

# since: (1, 5, 1)
func ceilDiv*[T: SomeInteger](x, y: T): T {.inline.} =
  when sizeof(T) == 8:
    type UT = uint64
  elif sizeof(T) == 4:
    type UT = uint32
  elif sizeof(T) == 2:
    type UT = uint16
  elif sizeof(T) == 1:
    type UT = uint8
  else:
    {.fatal: "Unsupported int type".}
  assert x >= 0 and y > 0
  when T is SomeUnsignedInt:
    assert x + y - 1 >= x
  ((x.UT + (y.UT - 1.UT)) div y.UT).T

################################

let
  N = stdin.readLine.parseInt()
  S = stdin.readLine

proc solve(): string =
  var
    isVisited = initHashSet[(int, int)]()
    (x, y) = (0, 0)
  isVisited.incl((0, 0))
  for s in S:
    if s == 'R':
      x += 1
    elif s == 'L':
      x -= 1
    elif s == 'U':
      y += 1
    else:
      y -= 1
    if (x, y) in isVisited:
      return "Yes"
    isVisited.incl((x, y))
  return "No"

echo solve()
