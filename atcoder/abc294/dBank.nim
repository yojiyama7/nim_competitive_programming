import std/[sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables, complex, random, deques, heapqueue, sets, macros]
{. warning[UnusedImport]: off, hint[XDeclaredButNotUsed]: off, hint[Name]: off .}

# {.since: (1, 1).}
template countIt*(s, pred: untyped): int =
  var result = 0
  for it {.inject.} in s:
    if pred: result += 1
  result
# {.since: (1, 1).}
func maxIndex*[T](s: openArray[T]): int =
  for i in 1..high(s):
    if s[i] > s[result]: result = i
# {.since: (1, 5, 1).}
func ceilDiv*[T: SomeInteger](x, y: T): T {.inline.} =
  when sizeof(T) == 8:
    type UT = uint64
  elif sizeof(T) == 4:
    type UT = uint32
  elif sizeof(T) == 2:
    type UT = uint16
  elif sizeof(T) == 1:
    type UT = uint8
  else:
    {.fatal: "Unsupported int type".}
  assert x >= 0 and y > 0
  when T is SomeUnsignedInt:
    assert x + y - 1 >= x
  ((x.UT + (y.UT - 1.UT)) div y.UT).T
# {.since: (1, 5, 1).}
func euclMod[T: SomeNumber](x, y: T): T =
  result = x mod y
  if result < 0:
    result += abs(y)
# {.since: (1, 3).} and Edited by me
proc toDeque*[T](x: openArray[T]): Deque[T] =
  result = initDeque()
  for item in items(x):
    result.addLast(item)

template newSeqWith*(len: int, init: untyped): untyped =
  var result = newSeq[typeof(init, typeOfProc)](len)
  for i in 0 ..< len:
    result[i] = init
  move(result) # refs bug #7295
macro toTuple(lArg: openArray, n: static[int]): untyped =
  let l = genSym()
  var t = newNimNode(nnkTupleConstr)
  for i in 0..<n:
    t.add quote do:
      `l`[`i`]
  quote do:
    (let `l` = `lArg`; `t`)
# 適当にコピペして来たHash https://github.com/nim-lang/Nim/issues/11764#issuecomment-611186437
proc hiXorLo(a, b: uint64): uint64 {.inline.} =
  {.emit: "__uint128_t r=a; r*=b; `result` = (r>>64)^r;".}
proc hashWangYi1*(x: int64|uint64|Hash): Hash {.inline.} =
  const P0 = 0xa0761d6478bd642f'u64
  const P1 = 0xe7037ed1a0b428db'u64
  const P5x8 = 0xeb44accab455d165'u64 xor 8'u64
  Hash(hiXorLo(hiXorLo(P0, uint64(x) xor P1), P5x8))
proc hash(x: int): Hash =
  x.hashWangYi1()
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

let
  (N, Q) = stdin.readLine.split.map(parseInt).toTuple(2)
  EVENT = newSeqWith(Q, stdin.readLine.split.map(parseInt))

# 呼ばれているか、訪れているかを気にしたい
# p =よばれる=> q =訪れる=> r
# pの最小値とqの最小値がわかればよい
# p, q+rの要素いくつか, r の3つのヒープを持って
# qの最小値が欲しいときにq+rとrを見比べて遅延評価
# q+rのヒープはqの最小値を取得するために使える
#
# 操作1は普通にイテレート的なことで良い
# 操作3に関しても(広義単調増加なので)普通にイテレート的なサムシング?で良い
#
# もっと最適化はできそうだけど考えるのやめ
# heap+countTableで最小値取得, contains, 挿入, 削除 を O(logN)ぐらいでできそう？
var
  p = initHeapQueue[int]()
  q_r = initHeapQueue[int]()
  r = initHeapQueue[int]()
for i in 1..N:
  p.push(i)
for event in EVENT:
  case event[0]:
  of 1:
    q_r.push(p.pop())
  of 2:
    let x = event[1]
    r.push(x)
  of 3:
    while q_r.len > 0 and r.len > 0 and q_r[0] == r[0]:
      discard q_r.pop()
      discard r.pop()
    echo q_r[0]
  else: discard

