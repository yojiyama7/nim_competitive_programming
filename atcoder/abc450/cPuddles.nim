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
  (H, W) = stdin.readLine.split.map(parseInt).toTuple(2)
  S = newSeqWith(H, stdin.readLine)

var res = 0
var visited = newSeqWith(H, newSeqWith(W, false))
for cy in 0..<H:
  for cx in 0..<W:
    if visited[cy][cx] or S[cy][cx] == '#':
      continue
    visited[cy][cx] = true
    var stack = @[(cx, cy)]
    var is_surrounded = true
    while stack.len > 0:
      let (tx, ty) = stack.pop()
      for (dx, dy) in [(0, 1), (1, 0), (0, -1), (-1, 0)]:
        let (x, y) = (tx+dx, ty+dy)
        if not (x in 0..<W and y in 0..<H):
          is_surrounded = false
          continue
        if visited[y][x] or S[y][x] == '#':
          continue
        visited[y][x] = true
        stack.add((x, y))
    if is_surrounded:
      res += 1

echo res
