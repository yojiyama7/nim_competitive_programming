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


proc pow(x, n, m: int): int =
  if n == 0:
    return 1
  if n mod 2 == 1:
    result = x * pow(x, n-1, m)
  else:
    result = pow(x, n div 2, m)^2
  result = result mod m

proc `mod=`(x: var int, m: int): void =
  x = x mod m

################################

# 算数難しい
# 値の異なる最上位の桁において数が大きい方をA, もう一方をBにして
# Bに大きな数を揃えるのが大事

const MOD = 998244353

let
  N = stdin.readLine.parseInt()
var
  A = stdin.readLine.toSeq.mapIt(it.int - '0'.int)
  B = stdin.readLine.toSeq.mapIt(it.int - '0'.int)

for i in 0..<N:
  if A[i] > B[i]:
    (A[i], B[i]) = (B[i], A[i])

var
  resultA, resultB = 0
for i, a in A.reversed():
  resultA += a * pow(10, i, MOD)
  resultA.mod= MOD
for i, b in B.reversed():
  resultB += b * pow(10, i, MOD)
  resultB.mod= MOD

var result = resultA * resultB
result.mod= MOD

echo result
