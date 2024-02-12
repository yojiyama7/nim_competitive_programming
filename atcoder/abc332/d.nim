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
  (H, W) = stdin.readLine.split.map(parseInt).toTuple(2)
var
  A = newSeqWith(H, stdin.readLine.split.map(parseInt))
  B = newSeqWith(H, stdin.readLine.split.map(parseInt))

proc `<`(a, b: seq[int]): bool =
  for i in 0..<a.len:
    if a[i] < b[i]:
      return true
    if a[i] > b[i]:
      return false
  return false

proc inversed(a: seq[seq[int]]): seq[seq[int]] = 
  let (h, w) = (a.len, a[0].len)
  result = newSeqWith(w, newSeqWith(h, -1))
  for i in 0..<h:
    for j in 0..<w:
      result[j][i] = a[i][j]

proc calcInvScore(a: seq[int]): int =
  for i, ai in a:
    let score = a[i+1 ..< ^0].countIt(it < ai)
    # echo score
    result += score

var result = 10^18
var rows = (0..<H).toSeq
while true:
  var cols = (0..<W).toSeq
  while true:
    var p = rows.mapIt(A[it])
    let pInv = p.inversed
    p = cols.mapIt(pInv[it]).inversed
    if p == B:
      let score = calcInvScore(rows) + calcInvScore(cols)
      # echo (rows, cols)
      result = min(result, score)
    if cols.nextPermutation() == false: break
  if rows.nextPermutation() == false: break

if result == 10^18:
  echo -1
else:
  echo result

# proc sortedPuzzle(p: seq[seq[int]]): seq[seq[int]] =
#   let q = p.sorted()
#   return q.inversed.sorted().inversed()

# let c = A.sortedPuzzle()
# let d = B.sortedPuzzle() 
# if c != d:
#   echo -1
#   quit()

# A.sorted()

# # tenntousuu
# var Arows = A.mapIt(ASorted.find(it.sorted()))
# var Acols = newSeqWith(0, 0)
# for i in 0..<W:
#   let x = (0..<H).mapIt(A[it][i]).sorted()
#   echo x
#   for j in 0..<W:
#     echo ((0..<H).mapIt(Asorted[it][j]).sorted(), )
#     if (0..<H).mapIt(Asorted[it][j]).sorted() == x:
#       Acols.add(j); break

# var Brows = B.mapIt(ASorted.find(it.sorted()))
# var Bcols = newSeqWith(0, 0)
# for i in 0..<W:
#   let x = (0..<H).mapIt(B[it][i]).sorted()
#   for j in 0..<W:
#     if (0..<H).mapIt(Asorted[it][j]).sorted() == x:
#       Bcols.add(j); break

# # echo (A, B)
# echo ((Arows, Acols), (Brows, Bcols))
# let rows = zip(Arows, Brows).sorted().mapIt(it[1])
# let cols = zip(Acols, Bcols).sorted().mapIt(it[1])
# echo (rows, cols)

# var result = 0
# for i in 0..<H:
#   let score = rows[i+1 ..< ^0].countIt(it < rows[i])
#   result += score
# # echo result
# for i in 0..<W:
#   let score = cols[i+1 ..< ^0].countIt(it < cols[i])
#   result += score
# echo result