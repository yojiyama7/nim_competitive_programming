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

################################

let
  (N, X, Y, Z) = stdin.readLine.split.map(parseInt).toTuple(4)
  A = stdin.readLine.split.map(parseInt)
  B = stdin.readLine.split.map(parseInt)

var s = (0..<N).mapIt((id: it, math: A[it], eng: B[it]))
var okIds = s.sortedByIt((it.math, -it.id))[^X ..< ^0]
              .mapIt(it.id)
              .toHashSet()
s = s.filterIt(it.id notin okIds)
okIds.incl(
  s.sortedByIt((it.eng, -it.id))[^Y ..< ^0]
    .mapIt(it.id)
    .toHashSet()
)
s = s.filterIt(it.id notin okIds)
okIds.incl(
  s.sortedByIt((it.math + it.eng, -it.id))[^Z ..< ^0]
    .mapIt(it.id)
    .toHashSet()
)
s = s.filterIt(it.id notin okIds)

for id in okIds.toSeq.sorted():
  echo id+1
