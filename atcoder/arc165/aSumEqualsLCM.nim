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

let T = stdin.readline.parseInt()

proc doPrimeFactorization(n: int): CountTable[int] =
  var x = n
  for i in 2..n:
    if i^2 >= n:
      break
    while x mod i == 0:
      x = x div i
      result.inc(i)
    if x mod i != 0:
      continue
    let a = x div i
    while x mod a == 0:
      x = x div a
      result.inc(a)
  if x > 1:
    result.inc(x)

for _ in 0..<T:
  let N = stdin.readLine.parseInt()
  let ct = N.doPrimeFactorization()
  
  if ct.len >= 2:
    echo "Yes"
  else:
    echo "No"
