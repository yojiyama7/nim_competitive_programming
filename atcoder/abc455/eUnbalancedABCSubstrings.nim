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
  S = stdin.readLine

var acc_a = @[0] & S.mapIt(if it == 'A': 1 else: 0).cumsummed()
var acc_b = @[0] & S.mapIt(if it == 'B': 1 else: 0).cumsummed()
var acc_c = @[0] & S.mapIt(if it == 'C': 1 else: 0).cumsummed()

let
  abc_diffs = (0..N).mapIt((acc_a[it] - acc_b[it], acc_a[it] - acc_c[it]))
  abc_score = abc_diffs.toCountTable.values.toSeq.mapIt(it * (it-1) div 2).sum()
  ab_diffs = (0..N).mapIt(acc_a[it] - acc_b[it])
  ab_score = ab_diffs.toCountTable.values.toSeq.mapIt(it * (it-1) div 2).sum()
  bc_diffs = (0..N).mapIt(acc_b[it] - acc_c[it])
  bc_score = bc_diffs.toCountTable.values.toSeq.mapIt(it * (it-1) div 2).sum()
  ca_diffs = (0..N).mapIt(acc_c[it] - acc_a[it])
  ca_score = ca_diffs.toCountTable.values.toSeq.mapIt(it * (it-1) div 2).sum()

let res = N * (N+1) div 2 - ab_score - bc_score - ca_score + 2*abc_score
echo res
