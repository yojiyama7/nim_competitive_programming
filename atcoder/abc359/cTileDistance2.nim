import std/[sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables, complex, random, deques, heapqueue, sets, macros, bitops]
{. warning[UnusedImport]: off, hint[XDeclaredButNotUsed]: off, hint[Name]: off .}

macro toTuple(lArg: openArray, n: static[int]): untyped =
  let l = genSym()
  var t = newNimNode(nnkTupleConstr)
  for i in 0..<n:
    t.add quote do:
      `l`[`i`]
  quote do:
    (let `l` = `lArg`; `t`)
proc pow(x, n, m: int): int =
  if n == 0:
    return 1
  if n mod 2 == 1:
    result = x * pow(x, n-1, m)
  else:
    result = pow(x, n div 2, m)^2
  result = result mod m
proc parseInt(c: char): int =
  c.int - '0'.int
iterator skipBy(r: HSlice, step: int): int =
  for i in countup(r.a, r.b, step):
    yield i
proc initHashSet[T](): Hashset[T] = initHashSet[T](0)

################################

<<<<<<< HEAD
=======
# 上下移動で必ずコスト
# 左右移動は斜め移動ならかからん
# 右上、右下、左上、左下にコスト1で行けるってこと？
# 真横も2だから、正6角形が敷き詰められているのと同じ？

proc fmtPos(t: (int, int)): (int, int) = 
  let (x, y) = t
  if x.euclMod(2) == y.euclMod(2):
    (x, y)
  else:
    (x-1, y)
proc closedToZero(a, b: int): int =
  assert b >= 0
  if a > 0:
    a - b
  else:
    a + b

var
  S = stdin.readLine.split.map(parseInt).toTuple(2)
  T = stdin.readLine.split.map(parseInt).toTuple(2)

let (gx, gy) = S.fmtPos()
let (x, y) = T.fmtPos()
# echo ((x, y), (gx, gy))

var result = 0
var (rx, ry) = (gx-x, gy-y)
# echo (rx, ry)
if rx.abs > 0 and ry.abs > 0:
  let d = min(rx.abs, ry.abs)
  rx = closedToZero(rx, d)
  ry = closedToZero(ry, d)
  # echo (rx, ry, d)
  result += d


# rx == 0 or ry == 0 である
if rx == 0:
  result += ry.abs
elif ry == 0:
  result += rx.abs.euclDiv(2)

echo result
>>>>>>> 9f416570f18a255d2ae92e106ccbca93a32ea945
