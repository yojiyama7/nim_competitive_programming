import std/[sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables, complex, random, deques, heapqueue, sets, macros]
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

################################

let 
  (N, M) = stdin.readLine.split.map(parseInt).toTuple(2)
  A = stdin.readLine.split.map(parseInt)
  S = newSeqWith(N, stdin.readLine)

var currentScores = newSeqWith(N, 0)
for i in 0..<N:
  for j, c in S[i]:
    if c == 'o':
      currentScores[i] += A[j]
  currentScores[i] += i+1

let currentMax = currentScores.max()

let problemIdxs = (0..<M).toSeq.sortedByIt(-A[it])

for i in 0..<N:
  if currentScores[i] == currentMax:
    echo 0
    continue
  var ans = 0
  var remain = currentMax - currentScores[i]
  for p in problemIdxs:
    if S[i][p] == 'o':
      continue
    remain -= A[p]
    ans += 1
    if remain <= 0:
      echo ans
      break
