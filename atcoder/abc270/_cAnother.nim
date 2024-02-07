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
proc initHashSet[T](): Hashset[T] = initHashSet[T](0)

################################

let
  (N, X1, Y1) = stdin.readLine.split.map(parseInt).toTuple(3)
  U1V1 = newSeqWith(N-1, stdin.readLine.split.map(parseInt).toTuple(2))

var g = newSeqWith(N, initHashSet[int]())
for (u1, v1) in U1V1:
  g[u1-1].incl(v1-1)
  g[v1-1].incl(u1-1)

var footprints = @[-1]
proc solve(t: int): void =
  # stdout.write &"{footprints.len}, "
  let b = footprints[^1]
  footprints.add(t)
  if t == Y1-1:
    echo footprints[1 ..< ^0].mapIt(it+1).join(" ")
    quit()
  for c in g[t] - [b].toHashSet():
    solve(c)
  discard footprints.pop()

solve(X1-1)
