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
  Q = stdin.readLine.parseInt()
  QUERY = newSeqWith(Q, stdin.readLine.split.map(parseInt))

proc toSortedSeq[T](hArg: HeapQueue[T]): seq[T] =
  var h = hArg
  while h.len > 0:
    result.add(h.pop())

var 
  aHeaps = initTable[int, HeapQueue[int]]()
  bHeaps = initTable[int, HeapQueue[int]]()
  bSets = initTable[int, HashSet[int]]()
for query in QUERY:
  case query[0]
  of 1:
    let (b, a) = (query[1]-1, query[2]-1)
    if a notin aHeaps: aHeaps[a] = initHeapQueue[int]()
    aHeaps[a].push(b)
    if b notin bSets: bSets[b] = initHashSet[int]()
    if a notin bSets[b]:
      if b notin bHeaps: bHeaps[b] = initHeapQueue[int]()
      bHeaps[b].push(a)
      if b notin bSets: bSets[b] = initHashSet[int]()
      bSets[b].incl(a)
  of 2:
    let a = query[1]-1
    echo aHeaps[a].toSortedSeq().mapIt(it+1).join(" ")
  of 3:
    let b = query[1]-1
    echo bHeaps[b].toSortedSeq().mapIt(it+1).join(" ")
  else: discard
