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
  S = stdin.readLine
  N = stdin.readLine.parseInt()
  T = newSeqWith(N, stdin.readLine)

proc isMatch(s, t: string): bool =
  if s.len != t.len:
    return false
  for (si, ti) in zip(s, t):
    if ti == '*':
      continue
    if si != ti:
      return false
  return true

var l = newSeq[string]()
for w in S.split(" "):
  let x = if T.anyIt(isMatch(w, it)):
            "*".repeat(w.len)
          else:
            w
  l.add(x)
echo l.join(" ")
