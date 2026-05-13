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

# https://atcoder.jp/contests/language-test-202505/tasks/arc065_a

import std/[strutils, unittest]  # unittest は例示用。必要なければ外して良い。

# s の start 位置から prefix で始まるかを返す（0-based）。
proc startsWithAt(s, prefix: string, start: int): bool =
  if start < 0: return false
  let sLen = s.len
  let pLen = prefix.len
  if pLen == 0: return start <= sLen   # 空文字は許容（sの末尾でも true）
  if start + pLen > sLen: return false
  for i in 0 ..< pLen:
    if s[start + i] != prefix[i]:
      return false
  return true

let S = stdin.readLine()

proc solve(i: int): bool =
  if i == S.len():
    return true
  for pat in ["dream", "dreamer", "erase", "eraser"]:
    if startsWithAt(S, pat, i):
      if solve(i + pat.len()):
        return true
  return false

if solve(0):
  echo "YES"
else:
  echo "NO"
