import std/[sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables, complex, random, deques, heapqueue, sets, macros, bitops]
{. warning[UnusedImport]: off, hint[XDeclaredButNotUsed]: off, hint[Name]: off .}

macro toTuple(lArg: openArray, n: static[int]): untyped =
  let l = genSym()
  var t = newNimNode(nnkTupleConstr)
  for i in 0..<n:
    t.add quote do:
      `l`[`i`]
  quote do:
    (let `l` = `lArg`; `t`)
proc pow(x, n, m: int): int =
  if n == 0:
    return 1
  if n mod 2 == 1:
    result = x * pow(x, n-1, m)
  else:
    result = pow(x, n div 2, m)^2
  result = result mod m
proc parseInt(c: char): int =
  c.int - '0'.int
iterator skipBy(r: HSlice, step: int): int =
  for i in countup(r.a, r.b, step):
    yield i
proc initHashSet[T](): Hashset[T] = initHashSet[T](0)

################################

let
  (N, X1, Y1) = stdin.readLine.split.map(parseInt).toTuple(3)
  U1V1 = newSeqWith(N-1, stdin.readLine.split.map(parseInt).toTuple(2))

var g = newSeqWith(N, initHashSet[int]())
for (u1, v1) in U1V1:
  g[u1-1].incl(v1-1)
  g[v1-1].incl(u1-1)

var
  currentPath = newSeq[int]()
  isVisited = newSeqWith(N, false)
  s = @[X1-1]
isVisited[X1-1] = true
while s.len > 0:
  let t = s.pop()
  currentPath.add(t)
  if t == Y1-1:
    echo currentPath.mapIt(it+1).join(" ")
  var hasNext = false
  for c in g[t]:
    if isVisited[c]:
      continue
    isVisited[c] = true
    s.add(c)
    hasNext = true
  if not hasNext:
    discard currentPath.pop()

################################

# let
#   (N, X1, Y1) = stdin.readLine.split.map(parseInt).toTuple(3)
#   U1V1 = newSeqWith(N-1, stdin.readLine.split.map(parseInt).toTuple(2))

# var g = newSeqWith(N, initHashSet[int]())
# for (u1, v1) in U1V1:
#   g[u1-1].incl(v1-1)
#   g[v1-1].incl(u1-1)

# proc solve(x: int): void =
#   if x == 0:
#     echo (1..N).toSeq.join(" ")
#     return
#   solve(x-1)

# solve(N)
# # echo (1..N).toSeq.join(" ")

################################

# let
#   (N, X1, Y1) = stdin.readLine.split.map(parseInt).toTuple(3)
#   U1V1 = newSeqWith(N-1, stdin.readLine.split.map(parseInt).toTuple(2))
# # let
# #   xxx = 70000
# #   (N, X1, Y1) = (xxx, 1, xxx)
# #   U1V1 = (X1..<Y1).mapIt((it, it+1))

# var g = newSeqWith(N, initHashSet[int]())
# for (u1, v1) in U1V1:
#   g[u1-1].incl(v1-1)
#   g[v1-1].incl(u1-1)

# var footprints = @[-1]
# proc solve(t: int): void =
#   let b = footprints[^1]
#   footprints.add(t)
#   if t == Y1-1:
#     echo footprints[1 ..< ^0].mapIt(it+1).join(" ")
#     quit()
#   for c in g[t] - [b].toHashSet():
#     solve(c)
#   discard footprints.pop()

# solve(X1-1)

################################

# let
#   (N, X1, Y1) = stdin.readLine.split.map(parseInt).toTuple(3)
#   U1V1 = newSeqWith(N-1, stdin.readLine.split.map(parseInt).toTuple(2))

# var g = newSeqWith(N, initHashSet[int]())
# for (u1, v1) in U1V1:
#   g[u1-1].incl(v1-1)
#   g[v1-1].incl(u1-1)

# var footprints = newSeq[int]()
# var visited = newSeqWith(N, false)
# visited[X1-1] = true
# var s = @[X1-1]
# while s.len > 1:
#   let t = s.pop()
#   footprints.add(t)
#   for c in g[t]:
#     if visited[c]:
#       continue
#     visited[c] = true
#     s.add(c)


# proc solve(t: int): void =
#   footprints.add(t)
#   if t == Y1-1:
#     echo footprints.mapIt(it+1).join(" ")
#     quit()
#   for c in g[t]:
#     if c in visited:
#       continue
#     visited.incl(c)
#     solve(c)
#   discard footprints.pop()

# visited.incl(X1-1)
# solve(X1-1)
