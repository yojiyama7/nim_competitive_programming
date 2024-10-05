import sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables
import complex, random, deques, heapqueue, sets, macros
{. warning[UnusedImport]: off, hint[XDeclaredButNotUsed]: off, hint[Name]: off .}

template newSeqWith*(len: int, init: untyped): untyped =
  var result = newSeq[typeof(init, typeOfProc)](len)
  for i in 0 ..< len:
    result[i] = init
  move(result) # refs bug #7295

# since (1, 1):
template countIt*(s, pred: untyped): int =
  var result = 0
  for it {.inject.} in s:
    if pred: result += 1
  result
# since (1, 1):
func maxIndex*[T](s: openArray[T]): int =
  for i in 1..high(s):
    if s[i] > s[result]: result = i

macro toTuple[T](a: openArray[T], n: static[int]): untyped =
  ## かなり原始的に書いている
  ## より短くはできるが見てわかりやすいように
  let tmp = genSym()
  let t = newNimNode(nnkPar)
  for i in 0..<n:
    t.add(
      newNimNode(nnkBracketExpr).add(
        tmp,
        newLit(i)
      )
    )
  result = newNimNode(nnkStmtListExpr).add(
    newNimNode(nnkLetSection).add(
      newNimNode(nnkIdentDefs).add(
        tmp,
        newNimNode(nnkEmpty),
        a
      )
    ),
    t
  )

# 書き換えて使う想定
const Modulo = 998244353
type ModInt = distinct int

proc toModInt(x: int): ModInt =
  ModInt( ((x mod Modulo) + Modulo) mod Modulo )

proc `$`(x: ModInt): string =
  $(x.int)

proc `+`(a, b: ModInt): ModInt =
  (a.int + b.int).toModInt
proc `+`(a: ModInt, b: int): ModInt =
  (a.int + b).toModInt
proc `+`(a: int, b: ModInt): ModInt =
  (a + b.int).toModInt
proc `-`(a, b: ModInt): ModInt =
  (a.int - b.int).toModInt
proc `-`(a: ModInt, b: int): ModInt =
  (a.int - b).toModInt
proc `-`(a: int, b: ModInt): ModInt =
  (a - b.int).toModInt
proc `*`(a, b: ModInt): ModInt =
  (a.int * b.int).toModInt
proc `*`(a: ModInt, b: int): ModInt =
  (a.int * b).toModInt
proc `*`(a: int, b: ModInt): ModInt =
  (a * b.int).toModInt

proc `+=`(a: var ModInt, b: int | ModInt): ModInt =
  a = a + b
proc `-=`(a: var ModInt, b: int | ModInt): ModInt =
  a = a - b
proc `*=`(a: var ModInt, b: int | ModInt): ModInt =
  a = a * b

################################

let S = stdin.readLine
let n = S.len

var cumSumByChar: array['a'..'z', seq[int]]
for c in 'a'..'z':
  cumSumByChar[c] = newSeq[int](n+1)
  for i in 0..<n:
    cumSumByChar[c][i+1] += cumSumByChar[c][i] + (S[i] == c).int
proc calcCharCount(c: char, l, r: int): int =
  cumSumByChar[c][r] - cumSumByChar[c][l]

var result = 0
var r = n
var beforeChar = '-'
for ei in (0..<n-2).toSeq.reversed():
  if S[ei] == S[ei+1] and S[ei+1] != S[ei+2]:
    let l = ei+2
    # echo (ei, n-l, (calcCharCount(S[ei], l, r)))
    if beforeChar == S[ei]:
      result += (r-l) - (calcCharCount(S[ei], l, r))
    else:
      result += (n-l) - (calcCharCount(S[ei], l, r))
    r = ei
    beforeChar = S[ei]
echo result

################################

# let S = stdin.readLine
# let n = S.len

# 前から見ていく
# 一度S[i]として有効だった種類の文字c(アルファベットの種類)は消費される
# 有効な場所に対してi+3境界以降のcの個数を数え n-(i+3) - c をスコアとする
# スコアを累計する
# ! 後ろから見ていかないとまずい
# anerroroccurred
#    rr. ....  ..: 7
#         cc.....
# 前から有効なポイントを取り出した後に、後ろから計算する必要あり？

# var cumSumByChar: array['a'..'z', seq[int]]
# for c in 'a'..'z':
#   cumSumByChar[c] = newSeq[int](n+1)
#   for i in 0..<n:
#     cumSumByChar[c][i+1] += cumSumByChar[c][i] + (S[i] == c).int

# var isConsumed: array['a'..'z', bool]
# var validEidx = newSeq[int]()
# for i in 0..<n-2:
#   if isConsumed[S[i]]:
#     continue
#   if S[i] == S[i+1] and S[i+1] != S[i+2]:
#     validEidx.add(i)
#     isConsumed[S[i]] = true

# var result = 0
# var rbi = n
# for eidx in validEidx.reversed:
#   let bi = eidx+2
#   let score = (n-bi) - (cumSumByChar[S[eidx]][rbi] - cumSumByChar[S[eidx]][bi])
#   result += score
#   echo (eidx, score, ((n-bi), (cumSumByChar[S[eidx]][rbi] - cumSumByChar[S[eidx]][bi])))
#   rbi = eidx
# echo result

################################

# 有効な箇所(2文字以上の連続)を右から消費する
# i番目に有効な箇所があるならi+2境界より右の個数回操作できる
# 長さnでi番目が有効なら、n-(i+2)回操作可能
# iはn-2未満
# ! i番目と同じ文字の個数分引く必要がある

# let S = stdin.readLine

# var charCounts = newSeqWith(26, newSeq[int](S.len+1))
# for i in 0..<26:
#   for j in 0..<S.len:
#     charCounts[i][j+1] = charCounts[i][j]
#     if S[j] == ('a'.int + i).char:
#       charCounts[i][j+1] += 1

# for l in charCounts:
#   echo l

# var result = 0
# for i in 0..<S.len-2:
#   if S[i] == S[i+1] and S[i+1] != S[i+2]:
#     result += S.len-(i+2)
#     result -= charCounts[S[i].int-'a'.int][S.len] - charCounts[S[i].int-'a'.int][i+3]

# echo result