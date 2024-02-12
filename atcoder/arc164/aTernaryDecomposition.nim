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

# 10進数で考えて3進数に直す

let T = stdin.readLine.parseInt()

for _ in 0..<T:
  let (N, K) = stdin.readLine.split.map(parseInt).toTuple(2)
  var
    ternaryDigits = newSeqWith(0, 0)
    x = N
  while x > 0:
    ternaryDigits.add(x mod 3)
    x = x div 3
  if (K in ternaryDigits.sum()..N) and (K mod 2 == N mod 2):
    echo "Yes"
  else:
    echo "No"