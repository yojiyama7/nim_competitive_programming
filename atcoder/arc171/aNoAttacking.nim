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

# NxN盤面においてA>Nの時、無理
# A==N の時 ギリギリ行けるが B==0を要求する
# A<Nの時いくつか空きマスがある上のほうから1行おきに開けるとよい

let T = stdin.readLine.parseInt()

for _ in 0..<T:
  let (N, A, B) = stdin.readLine.split.map(parseInt).toTuple(3)
  if A > N:
    echo "No"
    continue 
  if A == N:
    if B == 0:
      echo "Yes"
    else:
      echo "No"
    continue 
  # A < N
  let rw = N - A
  let rh = min(N - A, N.ceilDiv(2))
  if B <= rw*rh:
    echo "Yes"
  else:
    echo "No"