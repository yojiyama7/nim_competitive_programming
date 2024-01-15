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
  S = stdin.readLine

var bothMax = 0
var comproMax = 0
var a, b = 0
for c in S:
  if c == '0':
    bothmax = max(bothMax, a)
    comproMax = max(comproMax, b)
    a = 0
    b = 0
  elif c == '1':
    a += 1
  elif c == '2':
    a += 1
    b += 1
  bothmax = max(bothMax, a)
  comproMax = max(comproMax, b)

let result = max([0, bothMax-M, comproMax])
echo result
