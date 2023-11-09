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
  # echo result.treeRepr

proc just[T, U](x: T, f: T -> U): U =
  return x.f

################################

let (N, M) = stdin.readLine.split.map(parseInt).toTuple(2)

# https://docs.python.org/ja/3/library/itertools.html#itertools.combinations
# ここからコピペして来てみたがなぜ動くのか
# わかったかも
# permutationsを実装してみてその後にやると理解しやすいかも
iterator combinations(list: seq[int], n: int): seq[int] {.closure.} =
  if n > list.len:
    return
  var indexes = (0..<n).toSeq
  yield indexes.mapIt(list[it])
  while true:
    var x = -1
    for i in (0..<n).toSeq.reversed():
      if indexes[i] != (list.len - (n - i)):
        x = i
        break
    if x == -1:
      return
    indexes[x] += 1
    # 199 +1 = 200 で 99 が 00 になるみたいに
    # (これ以上大きくなれない桁が最小になる)
    # i桁目(indexes[i])における最小の値に戻るいめーじ？
    for i in x..<n-1:
      indexes[i+1] = indexes[i] + 1
    yield indexes.mapIt(list[it])

for p in combinations(toSeq(1..M), N):
  echo p.join(" ")
