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

# import rationals

let
  N = stdin.readLine.parseInt()
  AB = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(2))

type Rat = object
  num: int
  den: int
proc initRat(num, den: int): Rat =
  return Rat(num: num, den: den)
proc `<`(a, b: Rat): bool =
  a.num * b.den < b.num * a.den
proc `==`(a, b: Rat): bool = 
  a.num * b.den == b.num * a.den
proc cmpRat(a, b: Rat): int =
  if a < b: -1
  elif a == b: 0
  else: 1
proc probability(x: int): Rat = 
  let (a, b) = AB[x]
  return initRat(a, (a + b))
var people = (0..<N).toSeq.mapIt((probability(it), it))
people.sort((a, b) => (
  let r = -cmpRat(a[0], b[0])
  if r != 0: return r
  return cmp(a[1], b[1])
))
echo people.mapIt(it[1]+1).join(" ")
