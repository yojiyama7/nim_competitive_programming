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

proc settedBits(v: int, bits: varargs[int]): int =
  for b in bits:
    result.setBit(b)

for _ in 0..<T:
  let N = stdin.readLine.parseInt()
  if N < 7:
    echo -1
    continue
  var
    (a, b, c) = (2, 1, 0)
  while 0.settedBits(a+1, b, c) <= N:
    a += 1
  while a > b+1 and 0.settedBits(a, b+1, c) <= N:
    b += 1
  while b > c+1 and 0.settedBits(a, b, c+1) <= N:
    c += 1
  let result = 0.settedBits(a, b, c)
  # echo (result.toBin(64), result, (a, b, c), N)
  echo result

# ---

# for _ in 0..<T:
#   let N = stdin.readLine.parseInt()
#   if N < 7:
#     echo -1
#     continue
#   var result = 0
#   for i in 0..<3:
#     for j in 0..<int.high:
#       let current = result or (1 shl j)
#       if result.testBit(j+1):
#         result = current
#         break
#       let next = result or (1 shl (j+1))
#       if (current <= N) and (next > N):
#         result = current
#         break
#   echo (N, result, result.tobin(64), )
#   echo result
