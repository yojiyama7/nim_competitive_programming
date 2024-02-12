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

let A = newSeqWith(9, stdin.readLine.split.map(parseInt))

block solve:
  for i in 0..<9:
    if A[i].toHashSet().len != 9:
      echo "No"
      break solve
  for j in 0..<9:
    if (0..<9).mapIt(A[it][j]).toHashSet().len != 9:
      echo "No"
      break solve
  for bi in 0..<9:
    let
      (by, bx) = (bi div 3, bi mod 3)
      (y, x) = (by*3, bx*3)
    var nums = newSeqWith(0, 0).toHashSet()
    for cy in y..<y+3:
      for cx in x..<x+3:
        nums.incl(A[cy][cx])
    if nums.len != 9:
      echo "No"
      break solve
  echo "Yes"
