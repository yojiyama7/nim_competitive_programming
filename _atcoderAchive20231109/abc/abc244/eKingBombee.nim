import sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables
import complex, random, deques, heapqueue, sets, macros
{. warning[UnusedImport]: off, hint[XDeclaredButNotUsed]: off .}

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

const MOD = 998244353

let
  (N, M, K, S, T, X) = stdin.readLine.split.map(parseInt).toTuple(6)
  UV = newSeqWith(M, stdin.readline.split.map(parseInt).toTuple(2))

# XXX: newSeqWithが冗長
var g = newSeqWith(N, newSeqWith(0, 0))
for (u, v) in UV:
  g[u-1].add(v-1)
  g[v-1].add(u-1)

# ノードiに歩数jでXをk回(mod2)通って、たどり着くパターン数
var l = newSeqWith(N, newSeqWith(K+1, newSeqWith(2, 0)))
l[S-1][0][0] = 1

for j in 1..K:
  for i in 0..<N:
    if i == X-1:
      for c in g[i]:
        l[i][j][0] += l[c][j-1][1]
        l[i][j][1] += l[c][j-1][0]
    else:
      for c in g[i]:
        l[i][j][0] += l[c][j-1][0]
        l[i][j][1] += l[c][j-1][1]
    l[i][j][0] = l[i][j][0] mod MOD
    l[i][j][1] = l[i][j][1] mod MOD

# for li in l:
#   echo li
echo l[T-1][K][0]
