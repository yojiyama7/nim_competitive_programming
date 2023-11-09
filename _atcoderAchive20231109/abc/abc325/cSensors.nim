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

var
  isVisited = newSeqWith(H, newSeqWith(W, false))
  result = 0
for cy in 0..<H:
  for cx in 0..<W:
    if S[cy][cx] == '.':
      continue
    if isVisited[cy][cx]:
      continue
    var stack = newSeqWith(0, (0, 0))
    stack.add((cx, cy))
    while stack.len > 0:
      let
        t = stack.pop()
        (tx, ty) = t
      isVisited[ty][tx] = true
      for dy in -1..1:
        for dx in -1..1:
          if dx == 0 and dy == 0:
            continue
          let (x, y) = (tx+dx, ty+dy)
          if not (x in 0..<W and y in 0..<H):
            continue
          if S[y][x] != '#':
            continue
          if isVisited[y][x]:
            continue
          isVisited[y][x] = true
          stack.add((x, y))
    result += 1

echo result

################################

# let
#   (H, W) = stdin.readLine.split.map(parseInt).toTuple(2)
#   S = newSeqWith(H, stdin.readLine)

# for y in 0..<H:
#   for x in 0..<W:
#     echo (x, y)
# for (y, x) in product([0..<H, 0..<W]):
