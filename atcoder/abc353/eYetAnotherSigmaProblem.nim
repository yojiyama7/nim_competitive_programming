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

# これが賢いかも: https://atcoder.jp/contests/abc353/editorial/9980

let
  N = stdin.readLine.parseInt()
var
  S = stdin.readLine.split()
S.sort()

type
  NodeInner = object
    c: char                    # key
    cnt: int                   # value 1
    nexts: Table[char, Node]   # value 2
  Node = ref NodeInner

proc `$`(self: Node): string =
  var s = ""
  s &= "{cnt: " & $(self.cnt) & ", nexts: {\n"
  for i, (c, n) in self.nexts.pairs().toSeq:
    s &= c & ": " & $n
    if i != self.nexts.len:
      s &= ",\n"
  s = s.split("\n").join("\n  ")
  s &= "}}"
  return s

proc createNode(c: char): Node =
  result = new NodeInner
  result.c = c
  result.cnt = 0
  result.nexts = initTable[char, Node]()
proc add(self: var Node, c: char) =
  if not self.nexts.hasKey(c):
    self.nexts[c] = createNode(c)
  self.nexts[c].cnt += 1

var g = createNode('_')
for s in S:
  var tail = g
  for c in s:
    tail.add(c)
    tail = tail.nexts[c]

# echo g

var result = 0
var stack = @[g]
while stack.len > 0:
  let node = stack.pop()
  result += node.cnt * (node.cnt-1) div 2
  for next in node.nexts.values():
    stack.add(next)

echo result
