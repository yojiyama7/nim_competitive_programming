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
  (N, Q) = stdin.readLine.split.map(parseInt).toTuple(2)
  C1P1 = newSeqWith(Q, stdin.readLine.split.map(parseInt).toTuple(2))

var is_decks = newSeqWith(N, true)
var cards = (0..<N).mapIt((prev: -1, next: -1))
for (c1, p1) in C1P1:
  let (c, p) = (c1-1, p1-1)
  is_decks[c] = false
  if cards[c].prev != -1:
    cards[cards[c].prev].next = -1
  cards[p].next = c
  cards[c].prev = p

var result = newSeq[int]()
for i in 0..<N:
  if not is_decks[i]:
    result.add(0)
    continue
  var
    score = 0
    cur = i
  while cur != -1:
    cur = cards[cur].next
    score += 1
  result.add(score)

echo result.join(" ")
