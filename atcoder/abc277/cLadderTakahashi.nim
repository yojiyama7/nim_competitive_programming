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
  N = stdin.readLine.parseInt()
  AB = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(2))

var g = initTable[int, HashSet[int]]()
for (a1, b1) in AB:
  let (a, b) = (a1-1, b1-1)
  if a notin g:
    g[a] = initHashSet[int]()
  g[a].incl(b)
  if b notin g:
    g[b] = initHashSet[int]()
  g[b].incl(a)

var visited = initHashSet[int]()
visited.incl(0)
var stack = @[0]
while stack.len > 0:
  let t = stack.pop()
  if t notin g:
    continue
  for c in g[t]:
    if c in visited:
      continue
    visited.incl(c)
    stack.add(c)

echo visited.toSeq.max() + 1

################################
# ------------------------------
################################

# import std/[sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables, complex, random, deques, heapqueue, sets, macros, bitops]
# {. warning[UnusedImport]: off, hint[XDeclaredButNotUsed]: off, hint[Name]: off .}

# macro toTuple(lArg: openArray, n: static[int]): untyped =
#   let l = genSym()
#   var t = newNimNode(nnkTupleConstr)
#   for i in 0..<n:
#     t.add quote do:
#       `l`[`i`]
#   quote do:
#     (let `l` = `lArg`; `t`)
# proc pow(x, n, m: int): int =
#   if n == 0:
#     return 1
#   if n mod 2 == 1:
#     result = x * pow(x, n-1, m)
#   else:
#     result = pow(x, n div 2, m)^2
#   result = result mod m
# proc parseInt(c: char): int =
#   c.int - '0'.int
# iterator skipBy(r: HSlice, step: int): int =
#   for i in countup(r.a, r.b, step):
#     yield i

################################

# let 
#   N = stdin.readLine.parseInt()
#   AB1 = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(2))

# --------------------------------

# let 
#   N = stdin.readLine.parseInt()
#   AB1 = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(2))

# var scores = (0..<N).toseq()
# for (a1, b1) in AB1.sortedByIt(-it[1]):
#   var (a, b) = (a1-1, b1-1)
#   if a > b:
#     (a, b) = (b, a)
#   scores[a] = b

# echo scores
# echo scores[0]

# # --------------------------------

# # graph by seq

# let 
#   N = stdin.readLine.parseInt()
#   AB = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(2))

# var g = initTable[int, seq[int]]()
# for (a1, b1) in AB:
#   let (a, b) = (a1-1, b1-1)
#   if a notin g:
#     g[a] = newSeq[int]()
#   g[a].add(b)
#   if b notin g:
#     g[b] = newSeq[int]()
#   g[b].add(a)

# var visited = initHashSet[int]()
# visited.incl(0)
# proc solve(i: int) =
#   if i notin g:
#     return
#   for c in g[i]:
#     if c in visited:
#       continue
#     visited.incl(c)
#     solve(c)
# solve(0)

# # echo visited
# echo visited.toSeq.max() + 1

# --------------------------------

# # graph by HashSet

# let 
#   N = stdin.readLine.parseInt()
#   AB = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(2))

# var g = initTable[int, HashSet[int]]()
# for (a1, b1) in AB:
#   let (a, b) = (a1-1, b1-1)
#   if a notin g:
#     g[a] = initHashSet[int]()
#   g[a].incl(b)
#   if b notin g:
#     g[b] = initHashSet[int]()
#   g[b].incl(a)

# var visited = initHashSet[int]()
# visited.incl(0)
# proc solve(i: int) =
#   if i notin g:
#     return
#   for c in g[i]:
#     if c in visited:
#       continue
#     visited.incl(c)
#     solve(c)
# solve(0)

# # echo visited
# echo visited.toSeq.max() + 1


# --------------------------------

# graph by hashset(initHashset[int](1))
# なんでこれで通るの？？？

# let 
#   N = stdin.readLine.parseInt()
#   AB = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(2))

# var g = initTable[int, HashSet[int]]()
# for (a1, b1) in AB:
#   let (a, b) = (a1-1, b1-1)
#   if a notin g:
#     g[a] = initHashSet[int](1)
#   g[a].incl(b)
#   if b notin g:
#     g[b] = initHashSet[int](1)
#   g[b].incl(a)

# var visited = initHashSet[int](1)
# visited.incl(0)
# proc solve(i: int) =
#   if i notin g:
#     return
#   for c in g[i]:
#     if c in visited:
#       continue
#     visited.incl(c)
#     solve(c)
# solve(0)

# # echo visited
# echo visited.toSeq.max() + 1

# --------------------------------

# graph by hashset(defaultInitialSize = 0)

# proc initHashSet[T](): Hashset[T] = initHashSet[T](0)

# let 
#   N = stdin.readLine.parseInt()
#   AB = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(2))

# var g = initTable[int, HashSet[int]]()
# for (a1, b1) in AB:
#   let (a, b) = (a1-1, b1-1)
#   if a notin g:
#     g[a] = initHashSet[int]()
#   g[a].incl(b)
#   if b notin g:
#     g[b] = initHashSet[int]()
#   g[b].incl(a)

# var visited = initHashSet[int]()
# visited.incl(0)
# proc solve(i: int) =
#   if i notin g:
#     return
#   for c in g[i]:
#     if c in visited:
#       continue
#     visited.incl(c)
#     solve(c)
# solve(0)

# # echo visited
# echo visited.toSeq.max() + 1

