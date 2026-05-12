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

let (N, K) = stdin.readLine.split.map(parseInt).toTuple(2)

# 辞書順で 前半 or 後半 を判定したい
# もうちょい考察する
# (1,1,2,2)
# (1,2,1,2)
# (1,2,2,1)
# (2,1,1,2)
# (2,1,2,1)
# (2,2,1,1)
# 対称性がありそう
# 112233
# 112323
# ...
# 332211
# 012345のdiv2(0-idx)として考えれる
# これの半分として考えてもよさげ(対称性があるので？)
# 231405 -> 110202 -> 221313

# 0123 -> 0011
# 0132 -> 0011
# ...
# 3210 -> 1100
# (NK)!つのうち、同じパターンが2!2!ずつある

# 割と難解だな？

# 制限 && i番目まで確定していて残り部分について辞書順で
# 最初のもの
# 真ん中
# 最後
# の関数を再帰的に呼ぶ？

# 長さNのxから始まるものはxが何であっても同じ個数ある
# ということは、長さNで最初はN/2になるべき