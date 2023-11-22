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

var (H1, H2, H3, W1, W2, W3) = stdin.readLine.split.map(parseInt).toTuple(6)

var result = 0
for a in 1..W1:
  for b in 1..(W1-a):
    let c = W1-a-b
    if c <= 0: continue 
    for d in 1..W2:
      for e in 1..(W2-d):
        let f = W2-d-e 
        if f <= 0: continue 
        let g = H1-a-d
        if g <= 0: continue 
        let h = H2-b-e
        if h <= 0: continue 
        let
          i1 = W3-g-h
          i2 = H3-c-f
        if i1 != i2 or i1 <= 0: continue
        result += 1

echo result
