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
  A = newSeqWith(N, newSeqWith(N, stdin.readLine.split.map(parseInt)))
  Q = stdin.readLine.parseInt()
  XYZ = newSeqWith(Q, stdin.readLine.split.map(parseInt))

# echo XYZ

var accA = newSeqWith(N+1, newSeqWith(N+1, newSeqWith(N+1, 0)))
for i in 0..<N:
  for j in 0..<N:
    for k in 0..<N:
      accA[i+1][j+1][k+1] = A[i][j][k]
# echo accA
for i in 1..N:
  for j in 1..N:
    for k in 1..N:
      accA[i][j][k] += accA[i][j][k-1]
for i in 1..N:
  for j in 1..N:
    for k in 1..N:
      accA[i][j][k] += accA[i][j-1][k]
for i in 1..N:
  for j in 1..N:
    for k in 1..N:
      accA[i][j][k] += accA[i-1][j][k]

# echo accA

for xyz in XYZ:
  let lx = xyz[0]-1
  let rx = xyz[1]
  let ly = xyz[2]-1
  let ry = xyz[3]
  let lz = xyz[4]-1
  let rz = xyz[5]
  # echo (rx, ry, rz)
  var a = accA[rx][ry][rz]
  # echo a
  a -= accA[lx][ry][rz] + accA[rx][ly][rz] + accA[rx][ry][lz]
  # echo a
  a += accA[lx][ly][rz] + accA[lx][ry][lz] + accA[rx][ly][lz]
  # echo a
  a -= accA[lx][ly][lz]
  echo a
