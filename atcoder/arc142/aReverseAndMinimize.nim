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

let 
  (N, K) = stdin.readLine.split.map(parseInt).toTuple(2)

let 
  strK = $K
  dashK = strK.reversed.join().parseInt()

if K mod 10 == 0:
  if K in 1..N and (not dashK < K):
    echo 1
  else:
    echo 0
  quit()

if dashK < K:
  echo 0
  quit()

# K <= dashK and strK[^1] != '0'

var nums = initHashSet[int]()
for i in 0..<int.high:
  let x = K*10^i
  if x in 1..N:
    nums.incl(x)
  else:
    break
for i in 0..<int.high:
  let x = dashK*10^i
  if x in 1..N:
    nums.incl(x)
  else:
    break

echo nums.len