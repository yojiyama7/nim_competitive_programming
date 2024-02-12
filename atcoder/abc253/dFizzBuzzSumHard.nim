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
iterator skipBy(r: HSlice, step: int): int =
  for i in countup(r.a, r.b, step):
    yield i

################################

var (N, A, B) = stdin.readLine.split.map(parseInt).toTuple(3)

proc sumFromOneTo(n: int): int =
  (n * (n + 1)) div 2
proc sumOfMultiples(n, a: int): int = 
  (sumFromOneTo(n div a) * a)
proc forLoopCalc(n, a, b: int): int =
  for i in 1..n:
    if (i mod a == 0) or (i mod b == 0):
      continue
    result += i

proc solve(n, a, b: int): int =
  sumFromOneTo(n) - sumOfMultiples(n, a) - sumOfMultiples(n, b) + sumOfMultiples(n, lcm(a, b))

echo solve(N, A, B)
# let (N, A, B) = (60, 15, 10)
# echo (solve(N, A, B), forLoopCalc(N, A, B))

# for i in 1..100:
#   for j in 1..100:
#     for k in 1..100:
#       if solve(i, j, k) != forLoopCalc(i, j, k):
#         echo ((i, j, k), solve(i, j, k), forLoopCalc(i, j, k))
