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

type FenwickTree[T] = object 
  l*: seq[T]
proc extractLowestBit(x: int): int = x and -x
proc initFenwickTree*[T](): FenwickTree[T] =
  FenwickTree[T](l: newSeq[T](1))
proc push*[T](self: var FenwickTree[T], xRaw: T) =
  let n = self.l.len
  let k = extractLowestBit(n)
  var x = xRaw
  var d = 1
  while d != k:
    x += self.l[n - d]
    d *= 2
  self.l.add(x)
proc sumFromOneTo[T](self: var FenwickTree[T], bi: int): T =
  var rbidx = bi
  while rbidx != 0:
    result += self.l[rbidx]
    rbidx -= extractLowestBit(rbidx)
proc sumOf[T](self: var FenwickTree[T], lr: Slice[int]): T =
  let (l, r) = (lr.a, lr.b+1)
  return self.sumFromOneTo(r) - self.sumFromOneTo(l)
proc add[T](self: var FenwickTree[T], ei: int, v: T) =
  var bi = ei+1
  while bi < self.l.len:
    self.l[bi] += v
    bi += extractLowestBit(bi)

# type ModInt2 = distinct int
# proc toModInt2(x: int): auto = x.euclMod(2).ModInt2
# proc `+`(a, b: ModInt2): auto = (a.int + b.int).toModInt2
# proc `+=`(a: var ModInt2, b: ModInt2): auto = a = a + b

let 
  (N, Q) = stdin.readLine.split.map(parseInt).toTuple(2)
  S = stdin.readLine
  QUERY = newSeqWith(Q, stdin.readLine.split.map(parseInt).toTuple(3))

var ftBorder = initFenwickTree[int]()
ftBorder.push(1)
for i in 0..<N-1:
  if S[i] != S[i+1]:
    ftBorder.push(1)
  else:
    ftBorder.push(0)
ftBorder.push(1)

for (q, l1, r) in QUERY:
  let (l, r) = (l1-1, r)
  case q
  of 1:
    ftBorder.add(l, 1)
    if ftBorder.sumOf(l..l) == 2: ftBorder.add(l, -2)
    ftBorder.add(r, 1)
    if ftBorder.sumOf(r..r) == 2: ftBorder.add(r, -2)
  of 2:
    echo if ftBorder.sumOf(l+1..r-1) == r - l - 1:
      "Yes"
    else:
      "No"
  else: discard

################################

# type
#   ObjFenwickTree = object
#     l: seq[int]
#   FenwickTree = ref ObjFenwickTree

# proc lsb(x: int): int =
#   return x and -x
# proc initFenwickTree(n: int): FenwickTree =
#   FenwickTree(l: newSeq[int](n+1))
# proc push(self: FenwickTree, v: int) =
#   let n = self.l.len()
#   let nLsb = lsb(n)
#   var x = v
#   var d = 1  
#   while d != nLsb:
#     x += self.l[n-d]
#     d *= 2
# proc sumFromOneTo(self: FenwickTree, bidx: int): int =
#   var x = bidx
#   while x > 0:
#     result += self.l[x]
#     x -= lsb(x)
# proc sumOf(self: FenwickTree, slice: HSlice[int, int]): int =
#   let (a, b) = (slice.a, slice.b+1)
#   self.sumFromOneTo(b) - self.sumFromOneTo(a)
# proc add(self: FenwickTree, eidx: int, v: int) =
#   var x = eidx + 1
#   while x < self.l.len():
#     self.l[x] += v
#     x += lsb(x)

# let 
#   (N, Q) = stdin.readLine.split.map(parseInt).toTuple(2)
#   S = stdin.readLine()
#   QUERY = newSeqWith(Q, stdin.readLine.split.map(parseInt))

# var ft = initFenwickTree(N+1)
# for i in 1..<N-2:
#   if S[i-1] != S[i]:
#     ft.add(i, 1)

# for query in QUERY:
#   if query[0] == 1:
#     # 1-idx 閉区間
#     let (l, r) = (query[1], query[2])
#     ft.sumOf(l..)
#   else:
#     let (l, r) = (query[1]-1, query[2])
#     if ft.sumOf(l..<r-1) == r-l-1:
#       echo "Yes"
#     else:
#       echo "No"