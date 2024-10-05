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

let (L, R) = stdin.readLine.split.map(parseInt).toTuple(2)

# setされているbitのうち最下位のbitのみが立っている数を返す -> ある数の素因数の2のみを取り出すイメージ
proc lsb(x: int): int = 1 shl (x.firstSetBit - 1)

var (l, r) = (L, R)

var resultTailRev = newSeq[(int, int)]()
while 0 < r and l <= r - r.lsb: 
  resultTailRev.add (r-r.lsb, r)
  # echo ((l, r), r+r.lsb, r)
  r -= r.lsb

var resultHead = newSeq[(int, int)]()
while 0 < l and l + l.lsb <= r: 
  resultHead.add (l, l+l.lsb)
  # echo ((l, r), l, l+l.lsb)
  l += l.lsb

let result = resultHead & resultTailRev.reversed()
echo result.len
for (x, y) in result:
  echo &"{x} {y}"
