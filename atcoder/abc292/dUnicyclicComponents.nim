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
  (N, M) = stdin.readLine.split.map(parseInt).toTuple(2)
  UV = newSeqWith(M, stdin.readLine.split.map(parseInt).toTuple(2))

var g = newSeqWith(N, newSeq[int]())
for (u1, v1) in UV:
  let (u, v) = (u1-1, v1-1)
  g[u].add(v)
  g[v].add(u)

block solve:
  var isVisited = newSeqWith(N, false)
  for i in 0..<N:
    if isVisited[i]:
      continue
    isVisited[i] = true
    var
      s = @[i]
      nodeCnt = 1
      edgeDoubleCnt = 0
    while s.len > 0:
      let t = s.pop()
      for c in g[t]:
        edgeDoubleCnt += 1
        if isVisited[c]:
          continue 
        isVisited[c] = true
        nodeCnt += 1
        s.add(c)
    # echo (i, nodeCnt, edgeDoubleCnt)
    if nodeCnt != (edgeDoubleCnt div 2):
      echo "No"; break solve
  echo "Yes"
