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
iterator skipBy(r: HSlice, step: int): int =
  for i in countup(r.a, r.b, step):
    yield i

################################


let
  N = stdin.readLine.parseInt()
var
  A = stdin.readLine.split.map(parseInt)

# small(ちいさい方から N div 2 + 1 個)
# big(のこり N div 2 個)
# 最終的な並びの (0..<N).skipBy(2) 番目を下の段と呼ぶ
#                                  残りが上の段
# 下の段にはsmallが入ると考えていい
#- 上の段にsmallがあるとき、下の段にbigが同じ個数あるはず
#  - それらを交換しても状況が悪化しない
#  - 上の段の値はより大きく、下の段の値がより小さくなる
#    - これが悪影響を及ぼさない(成り立っていたら成り立ち続ける)

# 上の段の値は隣り合う下の段の値のより大きいほう、より大きい必要がある
# smallのうち値の大きいものはできるだけ、上の段のある場所に対して制限をつけるものになりたくない

# いろいろ考えると()
#  4 6 7
# 1 2 3 4
# 直感通り、こうするのが最善そう()

A.sort()

let 
  smalls = A[0 ..< (N div 2 + 1)]
  bigs = A[(N div 2 + 1) ..< ^0]

var bestA = newSeqWith(0, 0)
for i in 0..<N:
  if i mod 2 == 0:
    bestA.add(smalls[i div 2])
  else:
    bestA.add(bigs[i div 2])

# echo bestA

for i in (1..<N-1).skipBy(2):
  if not (bestA[i-1] < bestA[i] and bestA[i] > bestA[i+1]):
    echo "No"
    quit()
echo "Yes"
