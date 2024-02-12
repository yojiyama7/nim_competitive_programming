import sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables
import complex, random, deques, heapqueue, sets, macros
{. warning[UnusedImport]: off, hint[XDeclaredButNotUsed]: off, hint[Name]: off .}

# {.since: (1, 1).}
template countIt*(s, pred: untyped): int =
  var result = 0
  for it {.inject.} in s:
    if pred: result += 1
  result
# {.since: (1, 1).}:
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

################################

let
  N = stdin.readLine.parseInt
  S = newSeqWith(N, stdin.readLine.mapIt(($it).parseInt))

var result = 10000
for i in 0..9:
  let secByReels = S.map(reel => reel.find(i))
  let ct = secByReels.toCountTable
  let maxCnt = toSeq(ct.values).max()
  let loopCnt = maxCnt - 1
  let score = loopCnt*10 + toSeq(ct.pairs)
                            .filterIt(it[1] == maxCnt)
                            .mapIt(it[0])
                            .max()
  result = min(result, score)

echo result
