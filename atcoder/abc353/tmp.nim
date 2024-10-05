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

# const MOD = 10^9 + 7
# const INF = 10 shl 60
# echo (INF.euclMOD(MOD) * INF.euclMod(MOD)).euclMOD(MOD)

################################

# type
#   MyList = object
#     l: seq[int]
#   MyListRef = ref MyList
#   MyListElement = object
#     ml: MyListRef
#     idx: int
#   MyListElementRef = ref MyListElement
#   MyListElementRange = object
#     ml: MyListRef
#     slice: HSlice[int, int]
#   MyListElementRangeRef = ref MyListElementRange

# proc initMyList(): MyList =
#   MyList(l: newSeq[int]())
# proc newMyList(): MyListRef =
#   MyListRef(l: newSeq[int]())
# proc push(self: MyListRef, v: int) =
#   self.l.add((v div 2) * 2)

# # +=などのために、elementの参照を返す
# proc `[]`(self: MyListRef, idx: int): MyListElementRef =
#   MyListElementRef(ml: self, idx: idx)
# proc `[]`(self: MyListRef, slice: HSlice[int, int]): MyListElementRangeRef =
#   MyListElementRangeRef(ml: self, slice: slice)
# # 直接編集する
# proc `[]=`(self: MyListRef, idx: int, v: int) =
#   self.l[idx] = (v div 2) * 2
# # elementの参照に対して+=などを定義する
# proc `+=`(e: MyListElementRef, v: int) =
#   echo "element adding"
#   e.ml.l[e.idx] += (v div 2) * 2

# var ml = newMyList()
# for i in 0..<10:
#   ml.push(i)
# ml[0] += 3
# ml[1] = 15
# # ml[0..<10]
# echo ml.l

# var a = @[1, 4, 5, 6, 7, 3]
# a[0..<3] = @[1]
# echo a