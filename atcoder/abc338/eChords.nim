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
  AB = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(2))

# var nnn = 2
var t = newSeq[int](2*N)
for i, (a1, b1) in AB:
  # var (a, b) = ((a1-1 + nnn) mod (2*N), (b1-1 + nnn) mod (2*N))
  var (a, b) = (a1-1, b1-1)
  if a > b:
    swap(a, b)
  t[a] = i+1
  t[b] = -(i+1)

proc solve: bool =
  var s = newSeq[int]()
  for ti in t:
    if ti > 0:
      s.add(ti)
    else:
      if s.len == 0:
        return false
      if s[^1] != -ti:
        return false
      discard s.pop()
  return s.len == 0
# echo (solve(), t)

if solve():
  echo "No"
else:
  echo "Yes"
################################

# proc formattedEdge(t: (ModInt, ModInt)): (ModInt, ModInt) =
#   if t[0].v > t[1].v:
#     (t[1], t[0])
#   else:
#     t
# var edges = initHashSet[(ModInt, ModInt)]()
# for (a1, b1) in AB:
#   edges.incl(((a1-1).mi, (b1-1).mi))
# # echo edges

# var startEdge = (0.mi, 0.mi)
# for i in (0..<2*N).toSeq.map(mi):
#   let e = (i, i+1).formattedEdge()
#   if e in edges:
#     startEdge = e
#     break
# echo startEdge

# if startEdge == (0.mi, 0.mi):
#   echo "Yes"
#   quit()

# var a, b = 0.mi
# if startEdge == (0.mi, (2*N-1).mi):
#   (a, b) = ((2*N-1).mi, 0.mi)
# else:
#   (a, b) = startEdge
# edges.excl(startEdge)

# # var e = (-1, -1)
# while true:
#   let e1 = (a-2, a-1)
#   let e2 = (b+1, b+2)
#   let e3 = (a-1, b+1)
#   if e1 in edges:
#     edges.excl(e1)
#     a -= 2
#     continue
#   elif e2 in edges:
#     edges.excl(e2)
#     b += 2
#     continue
#   elif e3 in edges:
#     edges.excl(e3)
#     a -= 1
#     b += 1
#     continue
#   break

# # echo ((a, b), edges)

# if edges.len == 0:
#   echo "No"
# else:
#   echo "Yes"