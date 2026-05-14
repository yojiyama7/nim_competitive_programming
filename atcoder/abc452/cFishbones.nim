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
  N = stdin.readLine.parseInt()
  AB1 = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(2))
  M = stdin.readLine.parseInt()
  S = newSeqWith(M, stdin.readLine)

var cands = initHashSet[(int, int, char)]()
for s in S:
  for i, c in s:
    cands.incl((s.len, i, c))

for s in S:
  if s.len != N:
    echo "No"
    continue
  var is_all_valid = true
  for i, c in s:
    let (a, b1) = AB1[i]
    if (a, b1-1, c) notin cands:
      is_all_valid = false
      break
  if is_all_valid:
    echo "Yes"
  else:
    echo "No"

################################

# let
#   N = stdin.readLine.parseInt()
#   AB = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(2))
#   M = stdin.readLine.parseInt()
#   S = newSeqWith(M, stdin.readLine)

# ### [len][idx] == hashSet
# var t = newSeqWith(11, newSeqWith(11, initHashSet[char]()))
# for s in S:
#   for j, c in s:
#     t[s.len][j].incl(c)

# for s in S:
#   if s.len != N:
#     echo "No"
#     continue
#   var is_ok = true
#   for j, (a, b1) in AB:
#     if s[j] notin t[a][b1-1]:
#       is_ok = false
#       break
#   if is_ok:
#     echo "Yes"
#   else:
#     echo "No"
