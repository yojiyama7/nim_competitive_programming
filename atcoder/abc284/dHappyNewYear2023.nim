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

let T = stdin.readLine.parseInt()

proc mySqrt(x: int): int =
  let r = x.toFloat.sqrt.int
  for ri in [(r-1), r, (r+1)]:
    if ri < 0: continue
    if ri^2 == x: return ri
  return -1

var resultPairs = newSeq[(int, int)]()
for _ in 0..<T:
  let N = stdin.readLine.parseInt()
  for i in 2..<N:
    if i^3 > N: break
    if N mod i != 0:
      continue 
    var p = -1
    var q = -1
    if N mod i^2 == 0: # i^2
      p = i
      q = N div i^2
    else:                    # i
      p = (N div i).mySqrt()
      q = i
    resultPairs.add((p, q))
    break

var result = newSeq[int]()
for (p, q) in resultPairs:
  result.add(p)
  result.add(q)

const PATTERN = 8
when PATTERN == 1:
  for (p, q) in resultPairs:
    echo &"{p} {q}"
when PATTERN == 2:
  for r in result:
    echo r
when PATTERN == 3:
  for r in result:
    echo r
    echo ""
when PATTERN == 4:
  echo ""
  echo ""
  echo ""
  for r in result:
    echo r
  echo ""
  echo ""
  echo ""
when PATTERN == 5:
  echo result.join("\n")
when PATTERN == 6:
  echo result.join(" ")
when PATTERN == 7:
  echo result.join("           ")
when PATTERN == 8:
  const p = ["", " ", "\n", "  \n ", "        "]
  for i, r in result:
    echo r
    if i < result.len-1:
      echo p[rand(0..<p.len)]
