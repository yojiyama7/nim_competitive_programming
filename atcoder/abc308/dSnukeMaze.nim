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
  (H, W) = stdin.readLine.split.map(parseInt).toTuple(2)
  S = newSeqWith(H, stdin.readLine)

const SNUKE = "snuke"
if S[0][0] != 's':
  echo "No"
  quit()
var isSeen = newSeqWith(H, newSeqWith(W, false))
isSeen[0][0] = true
var s = @[(0, 0)]
while s.len > 0:
  let (tx, ty) = s.pop()
  let tChar = S[ty][tx]
  let nextChar = SNUKE[(SNUKE.find(tChar)+1) mod 5]
  # echo ((tx, ty), tChar, nextChar)
  for (dx, dy) in [(0, 1), (1, 0), (0, -1), (-1, 0)]:
    let (x, y) = (tx+dx, ty+dy)
    if not (x in 0..<W and y in 0..<H):
      continue 
    if S[y][x] != nextChar:
      continue
    if isSeen[y][x]:
      continue
    isSeen[y][x] = true
    s.add((x, y))

# echo isSeen

if isSeen[H-1][W-1]:
  echo "Yes"
else:
  echo "No"