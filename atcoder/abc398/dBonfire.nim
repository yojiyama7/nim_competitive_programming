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
  (N, R, C) = stdin.readLine.split.map(parseInt).toTuple(3)
  S = stdin.readLine

var offsetY, offsetX = 0
var smokes = [(0, 0)].toHashSet()
for s in S:
  case s
  of 'N':
    offsetY -= 1
  of 'S':
    offsetY += 1
  of 'W':
    offsetX -= 1
  of 'E':
    offsetX += 1
  else: discard
  smokes.incl((0 - offsetX, 0 - offsetY))
  let pos = (C - offsetX, R - offsetY)
  # echo (offsetX, offsetY), pos, smokes
  # for smoke in smokes:
  #   echo (smoke[0]+offsetX, smoke[1]+offsetY)
  if pos in smokes:
    stdout.write('1')
  else:
    stdout.write('0')
echo ""
