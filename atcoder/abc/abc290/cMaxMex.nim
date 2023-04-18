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
  (N, K) = stdin.readLine.split.map(parseInt).toTuple(2)
  A = stdin.readLine.split.map(parseInt)
# let
#   (N, K) = (3 * 10^5, 3 * 10^5)
#   A = (10^9-N+1..10^9).toSeq.join(" ").split.map(parseInt)

# let
#   N = 3*10^5-114032
#   K = N
# var
#   preA = (0..<N).toSeq
# preA.shuffle()
# let
#   A = preA.join(" ").split.map(parseInt)
# echo preA[..5]

proc solve(): int =
  # なぜfilterしないとTLEするのか?
  # hashsetが重いのか?
  # hashsetの拡張がボトルネック？

  let dedupA = A.filterIt(it < K).toHashSet.toSeq.sorted()
  let limit = min(dedupA.len, K)
  for i in 0..<limit:
    if i != dedupA[i]:
      return i
  return limit

  # let dedupA = A.toHashSet.toSeq.sorted()
  # let limit = min(dedupA.len, K)
  # for i in 0..<limit:
  #   if i != dedupA[i]:
  #     return i
  # return limit

echo solve()
