# for https://github.com/kemuniku/cplib/issues/233

import std/[sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables, complex, random, deques, heapqueue, sets, macros, bitops]
{. warning[UnusedImport]: off, hint[XDeclaredButNotUsed]: off, hint[Name]: off .}

# []+=を実装したい

type
  EvenList[T] = ref object        # 偶数のみ要素として持つ
    l: seq[T]
  EvenListElement[T] = ref object # 代入時、左辺になるための型
    list: EvenList[T]
    idx: int

proc newEvenListElement[T](list: EvenList[T], idx: int): EvenListElement[T] =
  new result
  result.list = list
  result.idx = idx
# `[]`で単に値をみたい時用
converter convertTo[T](self: EvenListElement[T]): T =
  self.list.l[self.idx]
proc `+=`[T](self: EvenListElement[T], v: T) =
  # `[]+=` に該当する処理
  self.list.l[self.idx] += v div 2 * 2 # 切り捨てて偶数に

proc newEvenList[T](n: int): EvenList[T] =
  new result
  result.l = newSeq[T](n)
proc `[]`[T](self: EvenList[T], idx: int): EvenListElement[T] =
  return newEvenListElement(self, idx)
proc `[]=`[T](self: EvenList[T], idx: int, v: T) =
  # `[]=` に該当する処理
  self.l[idx] = v div 2 * 2 # 切り捨てて偶数に
proc `$`[T](self: EvenList[T]): string =
  $(self[])

var evenList = newEvenList[int](10)
for i in 0..<10:
  evenList[i] = 2*i
echo (evenList[3], evenList)

evenList[3] = 45
echo (evenList[3], evenList)

evenList[1] += 11
echo (evenList[1], evenList)

# 出力
# (6, (l: @[0, 2, 4, 6, 8, 10, 12, 14, 16, 18]))
# (44, (l: @[0, 2, 4, 44, 8, 10, 12, 14, 16, 18]))
# (12, (l: @[0, 12, 4, 44, 8, 10, 12, 14, 16, 18]))