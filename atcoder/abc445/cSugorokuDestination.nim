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
  A = stdin.readLine.split.map(parseInt).mapIt(it - 1)

var memo = newSeqWith(N, -1)
for i in 0..<N:
  if memo[i] != -1:
    continue
  var stack = newSeq[int]()
  var cur = i
  while true:
    stack.add(cur)
    if cur == A[cur]:
      break
    cur = A[cur]
  let res = cur
  while stack.len > 0:
    memo[stack.pop] = res

echo memo.mapIt(it+1).join(" ")

################################

# let
#   N = stdin.readLine.parseInt()
#   A = stdin.readLine.split.map(parseInt).mapIt(it - 1)

# proc pow2(n, m, k: int): int =
#   # echo (n, m, k)
#   if m == 0:
#     return 1 mod k
#   if m == 1:
#     return n mod k
#   if m mod 2 == 0:
#     let h = pow2(n, m div 2, k)
#     return h*h mod k
#   return pow2(n, m-1, k) * n mod k

# var visited = newSeqWith(N, -1)
# var memo = newSeqWith(N, -1)
# var before = initTable[int, int]()
# proc solve(idx: int): int =
#   if memo[idx] != -1:
#     return memo[idx]
#   if visited[idx] != -1:
#     # echo idx
#     # echo memo
#     # echo visited
#     # echo before
#     # quit()
#     memo[idx] = before[solve(A[idx])]
#     return memo[idx]
#   var stack = newSeq[int]()
#   var cur = idx
#   var loop_idx = 0
#   while visited[cur] == -1:
#     visited[cur] = loop_idx
#     stack.add(cur)
#     cur = A[cur]
#     loop_idx += 1
#   stack.add(cur)
#   let anchor = cur
#   if memo[anchor] != -1:
#     return solve(idx)

#   # echo stack
#   # echo (loop_idx, visited[anchor])
#   var size = loop_idx - visited[anchor]
#   for i in 0..<size:
#     let v = stack[^(i+2)]
#     let k = stack[^(i+1)]
#     # echo (v, k)
#     before[k] = v
#   # echo idx
#   # echo visited
#   # echo before
#   # echo size

#   let remain = pow2(10, 100, size)
#   var res_cur = anchor
#   for _ in 0..<remain:
#     res_cur = A[res_cur]

#   memo[anchor] = res_cur
#   return solve(idx)

# var result = newSeq[int]()
# for i in 0..<N:
#   result.add(solve(i) + 1)

# echo result.join(" ")