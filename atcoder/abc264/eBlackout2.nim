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

type UnionFindX = object
  n: int
  parent: seq[int]
  # r prefixは根に対してのみ有効な値を持ち、それ以外に関しては参照されないものとする
  rSize: seq[int] 
  rRank: seq[int]
  rHasPower: seq[bool]
  rCityNum: seq[int]
  cityHasPowerNum: int

proc initUnionFindX(n: int, powerPlants: seq[int]): UnionFindX =
  var p = newSeqWith(n, false)
  var c = newSeqWith(n, 1)
  for x in powerPlants:
    p[x] = true
    c[x] = 0
  UnionFindX(
    n: n,
    parent: newSeqWith(n, -1),
    rSize: newSeqWith(n, 1),
    rRank: newSeqWith(n, 0),
    rHasPower: p,
    rCityNum: c,
    cityHasPowerNum: 0,
  )
proc root(uf: var UnionFindX, x: int): int =
  if uf.parent[x] == -1: return x
  uf.parent[x] = uf.root(uf.parent[x])
  return uf.parent[x]
proc isSame(uf: var UnionFindX, x, y: int): bool =
  uf.root(x) == uf.root(y)
proc unite(uf: var UnionFindX, x, y: int): bool =
  var (rx, ry) = (uf.root(x), uf.root(y))
  if rx == ry: return false
  if (uf.rRank[rx] < uf.rRank[ry]): swap(rx, ry)
  uf.parent[ry] = rx
  if uf.rRank[rx] == uf.rRank[ry]: uf.rRank[rx] += 1
  if uf.rHasPower[ry] and not uf.rHasPower[rx]:
    uf.cityHasPowerNum += uf.rCityNum[rx]
    uf.rHasPower[rx] = true
  elif uf.rHasPower[rx] and not uf.rHasPower[ry]:
    uf.cityHasPowerNum += uf.rCityNum[ry]
    uf.rHasPower[ry] = true
  uf.rCityNum[rx] += uf.rCityNum[ry]
  uf.rSize[rx] += uf.rSize[ry]
  return true
proc size(uf: var UnionFindX, x: int): int =
  uf.rSize[uf.root(x)]


# 時刻の向きを逆にしてunionFind?
let 
  (N, M, E) = stdin.readLine.split.map(parseInt).toTuple(3)
  U1V1 = newSeqWith(E, stdin.readLine.split.map(parseInt).toTuple(2))
  Q = stdin.readLine.parseInt()
  X1 = newSeqWith(Q, stdin.readLine.parseInt())

let X = X1.mapIt(it-1)
var setX = X.toHashSet()
var uf = initUnionFindX(N+M, (N..<N+M).toSeq)
for i, u1v1 in U1V1:
  if i in setX:
    continue
  let
    (u1, v1) = u1v1
    (u, v) = (u1-1, v1-1)
  discard uf.unite(u, v)

var resultRev = newSeq[int]()
for x in X.reversed:
  resultRev.add uf.cityHasPowerNum
  let
    (u1, v1) = U1V1[x]
    (u, v) = (u1-1, v1-1)
  discard uf.unite(u, v)

for r in resultRev.reversed:
  echo r
