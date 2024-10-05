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

const INF = 1 shl 60
let 
  N = stdin.readLine.parseInt()
  A = stdin.readLine.split.map(parseInt)

var ct = A.toCountTable()
var uniqueMangas = newSeq[int]()
var remain = 0
for k in ct.keys.toSeq.sorted():
  uniqueMangas.add(k)
  let r = ct[k]-1
  remain += r
  ct.inc(k, -r)
# ct[k]は0か1
# remainには交換用の本の数
# uniqueMangasはct[k]==1となるkが昇順で並んでる

for i in 1..INF:
  if ct.hasKey(i) and ct[i] >= 1:
    ct.inc(i, -1)
    continue
  if remain >= 2:
    remain -= 2
    continue
  while remain < 2:
    if uniqueMangas.len == 0:
      echo i-1; quit()
    let t = uniqueMangas.pop()
    if ct[t] == 0:
      echo i-1; quit()
    ct.inc(t, -1)
    remain += 1
  remain -= 2
