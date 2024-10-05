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

# A[0], A[1] が決まると全部決まる

# S[i] - A[i] + A[i+3] = S[i+1]
# A[i+3] - A[i] = S[i+1] - S[i] = diff
# A[0], A[1]をできるだけ小さくして、かつ0未満にならないようにする
# A[2]がは自動的に決まって、これで条件を満たせるかどうかがそのまま問題

let 
  N = stdin.readLine.parseInt()
  S = stdin.readLine.split.map(parseInt)

var zeroScore = 0 # A[0]が0スタートなら
var zeroMin = 0
var oneScore = 0 # A[1]が0スタートなら
var oneMin = 0
var twoScore = 0 # A[2]が0スタートなら
var twoMin = 0
for i in 0..<N-1:
  let diff = S[i+1] - S[i]
  if i mod 3 == 0:
    zeroScore += diff
    zeroMin = min(zeroMin, zeroScore)
  elif i mod 3 == 1:
    oneScore += diff
    oneMin = min(oneMin, oneScore)
  else:
    twoScore += diff
    twoMin = min(twoMin, twoScore)

let req = -zeroMin + -oneMin + -twoMin
if req <= S[0]:
  echo "Yes"
  var result = @[-zeroMin, -oneMin]
  for i in 0..<N:
    let result_iPlus2 = S[i]-result[i]-result[i+1]
    result.add(result_iPlus2)
  echo result.join(" ")
else:
  echo "No"
