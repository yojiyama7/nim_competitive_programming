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
  (H, W) = stdin.readLine.split.map(parseInt).toTuple(2)
  S = newSeqWith(H, stdin.readLine)

var (a, b, c, d) = (H, -1, W, -1)
for y, s in S:
  for x, tile in s:
    if tile == '#':
      a = min(a, y)
      b = max(b, y)
      c = min(c, x)
      d = max(d, x)

for y in a..b:
  for x in c..d:
    if S[y][x] == '.':
      echo &"{y+1} {x+1}"
