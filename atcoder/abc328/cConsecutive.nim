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

################################

let
  (N, Q) = stdin.readLine.split.map(parseInt).toTuple(2)
  S = stdin.readLine
  LR = newSeqWith(Q, stdin.readLine.split.map(parseInt).toTuple(2))

var scoreSumsFromFirst = @[0]
for i in 0..<S.len-1:
  let score = if S[i] == S[i+1]:
                1
              else:
                0
  scoreSumsFromFirst.add(scoreSumsFromFirst[^1] + score)

for (l1, r1) in LR:
  echo scoreSumsFromFirst[r1-1] - scoreSumsFromFirst[l1-1]
