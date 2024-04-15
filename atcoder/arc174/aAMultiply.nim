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
  (N, C) = stdin.readLine.split.map(parseInt).toTuple(2)
  A = stdin.readLine.split.map(parseInt)

#@# これって抽象化行えませんか？

if C > 0:
  var accA = newSeq[int](N+1)
  for i in 0..<N:
    accA[i+1] = accA[i] + A[i]
  var rightRangeMin = newSeq[int](N+1)
  var rightRangeMinIdx = newSeq[int](N+1)
  rightRangeMinIdx[N] = N
  for i in countdown(N-1, 0):
    let score = accA[N] - accA[i]
    if score < rightRangeMin[i+1]:
      rightRangeMin[i] = score
      rightRangeMinIdx[i] = i
    else:
      rightRangeMin[i] = rightRangeMin[i+1]
      rightRangeMinIdx[i] = rightRangeMinIdx[i+1]

  var 
    maxScore = 0
    maxScoreRange = (0, 0)
  for l in 0..<N:
    let r = rightRangeMinIdx[l]
    let score = accA[r] - accA[l]
    if score >= maxScore:
      maxScore = score
      maxScoreRange = (l, r)
  
  let (l, r) = maxScoreRange
  let result = accA[l] + (accA[r] - accA[l])*C + (accA[N] - accA[r])
  echo result
else:
  var accA = newSeq[int](N+1)
  for i in 0..<N:
    accA[i+1] = accA[i] + A[i]
  var rightRangeMax = newSeq[int](N+1)
  var rightRangeMaxIdx = newSeq[int](N+1)
  rightRangeMaxIdx[N] = N
  for i in countdown(N-1, 0):
    let score = accA[N] - accA[i]
    if score > rightRangeMax[i+1]:
      rightRangeMax[i] = score
      rightRangeMaxIdx[i] = i
    else:
      rightRangeMax[i] = rightRangeMax[i+1]
      rightRangeMaxIdx[i] = rightRangeMaxIdx[i+1]

  var 
    minScore = 0
    minScoreRange = (0, 0)
  for l in 0..<N:
    let r = rightRangeMaxIdx[l]
    let score = accA[r] - accA[l]
    if score <= minScore:
      minScore = score
      minScoreRange = (l, r)
  
  let (l, r) = minScoreRange
  let result = accA[l] + (accA[r] - accA[l])*C + (accA[N] - accA[r])
  echo result
