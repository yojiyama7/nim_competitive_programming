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
proc parseInt(c: char): int =
  c.int - '0'.int

################################

let
  (N, M) = stdin.readLine.split.map(parseInt).toTuple(2)
var
  PCF = newSeqWith(N, stdin.readLine.split.map(parseInt))

for i, pcf1 in PCF:
  for j, pcf2 in PCF:
    if i == j:
      continue
    let (p1, c1, f1) = (pcf1[0], pcf1[1], pcf1[2..< ^0].toHashSet())
    let (p2, c2, f2) = (pcf2[0], pcf2[1], pcf2[2..< ^0].toHashSet())
    if not (p1 <= p2):
      continue
    if not ((f2 - f1).len == 0):
      continue
    if not ((f1 - f2).len >= 1 or p1 < p2):
      continue
    echo "Yes"
    quit()
echo "No"
