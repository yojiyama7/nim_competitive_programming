import std/[sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables, complex, random, deques, heapqueue, sets, macros]
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

################################

let 
  (N, M)= stdin.readLine.split.map(parseInt).toTuple(2)
  A = stdin.readLine.split.map(parseInt).toHashSet()

var result = newSeqWith(N, 0)
for i in (0..<N-1).toSeq.reversed:
  if i+1 in A:
    result[i] = 0
  else:
    result[i] = result[i+1] + 1
for r in result:
  echo r