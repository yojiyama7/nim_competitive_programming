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
  N = stdin.readLine.parseInt()
  SC = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(2))

var
  counts = initTable[int, int]()
  heap = initHeapQueue[int]()
for (s, c) in SC:
  heap.push(s)
  counts[s] = c

while heap.len > 0:
  # echo heap
  let size = heap.pop()
  if counts[size] >= 2:
    # echo (size, counts[size])
    if 2*size notin counts:
      counts[2*size] = 0
    counts[2*size] += counts[size] div 2
    counts[size] = counts[size] mod 2
    heap.push(2*size)

echo counts.values.toSeq.sum()