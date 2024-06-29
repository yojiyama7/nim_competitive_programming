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

# これどっちもヒープで良くね？()

type FenwickTree[T] = object 
  l*: seq[T]
proc len(ft: var FenwickTree): int =
  return ft.l.len-1
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
const INF = 1 shl 60

let 
  (N, K) = stdin.readLine.split.map(parseInt).toTuple(2)
  A = stdin.readLine.split.map(parseInt)

proc mostLeftMoreThanZero(ft: var FenwickTree[int]): int =
  if ft.sumFromOneTo(ft.len) == 0:
    return -1
  var (ng, ok) = (0, ft.len)
  while abs(ok - ng) > 1:
    let mid = (ok + ng) div 2
    if ft.sumFromOneTo(mid) >= 1:
      ok = mid
    else:
      ng = mid
  return ok

var ft = initFenwickTree[int]()
for i in 0..<N:
  ft.push(0)
var hNeg = initHeapQueue[tuple[vNeg: int, idx: int]]()
for i in K..<N:
  hNeg.push((-A[i], i))
var currentMin = INF
var result = INF
for l in (0..<K).toSeq.reversed:
  if A[l] >= currentMin:
    continue
  currentMin = A[l]
  while hNeg.len > 0 and -(hNeg[0].vNeg) > A[l]:
    ft.add(hNeg.pop().idx, 1)
  let rbidx = ft.mostLeftMoreThanZero()
  if rbidx == -1:
    continue
  # echo ((l, rbidx-1), (0..<N).mapIt(ft.sumOf(it..it)), hNeg[0])
  let score = rbidx-1-l
  result = min(result, score)

if result == INF:
  echo -1
else:
  echo result