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

let 
  N = stdin.readLine.parseInt()
  X = stdin.readLine.split.map(parseInt)
  C = stdin.readLine.split.map(parseInt)

var g = newSeq[HashSet[int]](N)
for i, x1 in X:
  g[i].incl(x1-1)
  g[x1-1].incl(i)
var h = X.mapIt(it-1)

iterator connectedNodes(g: seq[HashSet[int]]): HashSet[int] =
  var isVisited = newSeq[bool](g.len)
  for i in 0..<g.len:
    if isVisited[i]:
      continue 
    var nodes = initHashSet[int]()
    isVisited[i] = true
    nodes.incl(i)
    var s = @[i]
    while s.len > 0:
      let t = s.pop()
      for c in g[t]:
        if isVisited[c]:
          continue
        isVisited[c] = true
        nodes.incl(c)
        s.add(c)
    yield nodes

var result = 0
for nodes in connectedNodes(g):
  var visited = initHashSet[int]()
  let start = nodes.toSeq[0]
  var q = @[start]
  var c = start
  while c notin visited:
    visited.incl(c)
    q.add(c)
    c = h[c]
  let loop = q[q.find(c)..^1]
  let cost = loop.mapIt(C[it]).min()
  result += cost

echo result

# var result = 0
# var isVisited = newSeqWith(N, false)
# for i in 0..<N:
#   if isVisited[i]:
#     continue 
#   var nodes = initHashSet[int]()
#   isVisited[i] = true
#   nodes.incl(i)
#   var s = @[i]
#   while s.len > 0:
#     let t = s.pop()
#     for c in g[t]:
#       if isVisited[c]:
#         continue
#       isVisited[c] = true
#       nodes.incl(c)
#       s.add(c)
#   # find loop
#   var visited = initHashSet[int]()
#   var q = @[i]
#   var c = i
#   while c notin visited:
#     visited.incl(c)
#     q.add(c)
#     c = h[c]
#   let loop = q[q.find(c)..^1]
#   let cost = loop.mapIt(C[it]).min()
#   result += cost

# echo result