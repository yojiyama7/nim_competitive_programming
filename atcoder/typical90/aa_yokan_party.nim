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

################################################################

let
  (N, L) = stdin.readLine.split.map(parseInt).toTuple(2)
  K = stdin.readLine.parseInt()
  A = stdin.readLine.split.map(parseInt)

proc is_ok(x: int): bool =
  var cnt = 0
  var before_a = 0
  for a in A & @[L]:
    if (a - before_a) >= x:
      cnt += 1
      before_a = a
  return cnt >= K + 1

var (ok, ng) = (0, 10^9)
while abs(ok - ng) > 1:
  let mid = (ok + ng) div 2
  if is_ok(mid):
    ok = mid
  else:
    ng = mid

echo ok
