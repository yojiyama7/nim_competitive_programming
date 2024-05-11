# fenwick tree
# .push(x)      : 要素を最後尾に追加
# .prefixSum(i) : i番目(0 or 1 idx)までの総和
# .add(i, a)    : i番目にaを加算

type
  FenwickTree[T: int or float] = object
    n: int
    l: seq[T]

proc initFenwickTree[T: int or float](n: int): FenwickTree[T] =
  result.n = n
  result.l = newSeq[T](n)

echo initFenwickTree[int](10)
