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

var
  (N, C) = stdin.readLine.split.map(parseInt).toTuple(2)
  A = stdin.readLine.split.map(parseInt)

################################

# var
#   (N, C) = stdin.readLine.split.map(parseInt).toTuple(2)
#   A = stdin.readLine.split.map(parseInt)

# if C < 0:
#   C = abs(C)
#   A = A.mapIt(abs(it))

# var accAFromRight = newSeq[int](N+1)
# for i in countdown(N-1, 0):
#   accAFromRight[i] = A[i] + accAFromRight[i+1]
# var accAFromRightMin = newSeq[int](N+1)
# var accAFromRightMinIdx = newSeq[int](N+1)
# accAFromRightMinIdx[N] = N
# for i in countdown(N-1, 0):
#   if accAFromRight[i] < accAFromRightMin[i+1]:
#     accAFromRightMin[i] = accAFromRight[i]
#     accAFromRightMinIdx[i] = i
#   else:
#     accAFromRightMin[i] = accAFromRightMin[i+1]
#     accAFromRightMinIdx[i] = accAFromRightMinIdx[i+1]

# var accA = newSeq[int](N+1)
# for i1 in 1..N:
#   accA[i1] = accA[i1-1] + A[i1-1]

# var result = 0
# for i in 0..<N:
#   # i以降であるjでj..<N番目の要素の和が最小であるようなj
#   let j = accAFromRightMinIdx[i]
#   let score = (accA[j] - accA[i]) * C
#   result = max(result, score)

# echo result