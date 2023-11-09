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

type
  UnionFind = object
    parent: seq[int]
    size: seq[int]

proc initUnionFind(n: int): UnionFind =
  result.parent = newSeqWith[int](n, -1)
  result.size = newSeqWith[int](n, 1)

proc findRoot(uf: var UnionFind, x: int): int =
  if uf.parent[x] == -1:
    return x
  else:
    let root = uf.findRoot(uf.parent[x])
    uf.parent[x] = root
    return root

proc unite(uf: var UnionFind, x: int, y: int) =
  var xRoot = uf.findRoot(x)
  var yRoot = uf.findRoot(y)
  if xRoot == yRoot:
    return
  if uf.size[xRoot] < uf.size[yRoot]:
    swap(xRoot, yRoot)

  uf.parent[yRoot] = xRoot
  uf.size[xRoot] += uf.size[yRoot]

proc getSize(uf: var UnionFind, x: int): int =
  uf.size[uf.findRoot(x)]

proc isRoot(uf: var UnionFind, x: int): bool =
  uf.parent[x] == -1

################################

let
  (N, M) = stdin.readLine.split.map(parseInt).toTuple(2)
  UV = newSeqWith(M, stdin.readLine.split.map(parseInt).toTuple(2))

var uf = initUnionFind(N)
for (u, v) in UV:
  uf.unite(u-1, v-1)

echo (0..<N).countIt(uf.isRoot(it))

