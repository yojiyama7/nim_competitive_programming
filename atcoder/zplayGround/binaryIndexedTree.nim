# fenwick tree
# .push(x)      : 要素を最後尾に追加
# .prefixSum(i) : i番目(0 or 1 idx)までの総和
# .add(i, a)    : i番目にaを加算
import bitops, sequtils

type
  FenwickTree[T: int or float] = object
    l: seq[T]

proc initFenwickTree[T: int or float](n: int): FenwickTree =
  result.l = newSeq[T](n)
# proc `[]`[T: int or float](self: var FenwickTree[T], eidx) =

proc sumFromOneTo[T: int or float](self: FenwickTree[T], bidx: int): int =
  var x = bidx
  while x > 0:
    result += self.l[x]
    x -= (x and -x)
proc sumOf[T: int or float](self: FenwickTree[T], r: HSlice): int =
  let (l, r) = (r.a, r.b+1)
  sumFromOneTo(r) - sumFromOneTo(l)

proc add[T: int or float](self: var FenwickTree[T], eidx: int, v: int) =
  var x = eidx+1
  while x <= self.l.len:
    self.l[x] += v
    x += (x and -x)
