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

const INF = 1 shl 62
# QUESTION: これ遅い？ -> んなことないわ
proc isqrt(n: int): int =
  var x = n
  var y = (x + 1) div 2
  while y < x:
    x = y
    y = (x + n div x) div 2
  return x

let (N, M) = stdin.readLine.split.map(parseInt).toTuple(2)

var dxdySet = initHashSet[(int, int)]()
for i in 0..INF:
  if M < i^2:
    break
  let
    jjMaybe = (M-i^2)
    # jMaybe = (jjMaybe.toFloat().sqrt() + 1e-9).toInt()
    jMaybe = jjMaybe.isqrt()
  # echo (jjMaybe, jMaybe)
  if jMaybe^2 != jjMaybe:
    continue
  let j = jMaybe
  dxdySet.incl((i, j))
  dxdySet.incl((-i, j))
  dxdySet.incl((i, -j))
  dxdySet.incl((-i, -j))

# echo dxdySet

var board = newSeqWith(N, newSeqWith(N, INF))
board[0][0] = 0
var q = @[(0, 0)].toDeque()
while q.len > 0:
  let (tx, ty) = q.popFirst()
  for (dx, dy) in dxdySet:
    let (x, y) = (tx+dx, ty+dy)
    if not (x in 0..<N and y in 0..<N):
      continue
    if board[y][x] <= board[ty][tx] + 1:
      continue
    board[y][x] = board[ty][tx] + 1
    q.addLast((x, y))
  # echo q

for line in board:
  echo line.mapIt(if it == INF: -1 else: it).join(" ")
