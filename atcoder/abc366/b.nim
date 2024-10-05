import std/[sequtils, strutils, strformat, strscans, algorithm, math, sugar,
    hashes, tables, complex, random, deques, heapqueue, sets, macros, bitops]
{.warning[UnusedImport]: off, hint[XDeclaredButNotUsed]: off, hint[Name]: off.}

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
  S = newSeqWith(N, stdin.readLine())

let M = S.mapIt(it.len).max()
var m = newSeqWith(M, " ".repeat(N))

for i, s in S:
  for j, c in s:
    m[j][^(i+1)] = S[i][j]

for i in 0..<M:
  var flag = false
  for j in (0..<N).toSeq.reversed():
    if m[i][j] != ' ':
      flag = true
    else:
      if flag:
        m[i][j] = '*'
for line in m:
  echo line
