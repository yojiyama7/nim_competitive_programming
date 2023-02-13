import sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables
import complex, random, deques, heapqueue, sets, macros
{. warning[UnusedImport]: off, hint[XDeclaredButNotUsed]: off .}

template newSeqWith*(len: int, init: untyped): untyped =
  var result = newSeq[typeof(init, typeOfProc)](len)
  for i in 0 ..< len:
    result[i] = init
  move(result) # refs bug #7295

template countIt*(s, pred: untyped): int =
  var result = 0
  for it {.inject.} in s:
    if pred: result += 1
  result

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
  # echo result.treeRepr

proc just[T, U](x: T, f: T -> U): U =
  return x.f

proc isFilled(hcode: Hash): bool {.inline.} =
  result = hcode != 0
iterator pairs*[A, B](t: TableRef[A, B]): (A, B) =
  ## Iterates over any `(key, value)` pair in the table `t`.
  ##
  ## See also:
  ## * `mpairs iterator<#mpairs.i,TableRef[A,B]>`_
  ## * `keys iterator<#keys.i,TableRef[A,B]>`_
  ## * `values iterator<#values.i,TableRef[A,B]>`_
  ##
  ## **Examples:**
  ##
  ## .. code-block::
  ##   let a = {
  ##     'o': [1, 5, 7, 9],
  ##     'e': [2, 4, 6, 8]
  ##     }.newTable
  ##
  ##   for k, v in a.pairs:
  ##     echo "key: ", k
  ##     echo "value: ", v
  ##
  ##   # key: e
  ##   # value: [2, 4, 6, 8]
  ##   # key: o
  ##   # value: [1, 5, 7, 9]
  let L = len(t)
  for h in 0 .. high(t.data):
    if isFilled(t.data[h].hcode):
      yield (t.data[h].key, t.data[h].val)
      assert(len(t) == L, "the length of the table changed while iterating over it")

################################

let
  N = stdin.readLine.parseInt
  XY = newSeqWith(N, stdin.readLine.split.map(parseInt).toTuple(2))
  S = stdin.readLine
echo N
echo XY
echo S

let table = newTable[int, seq[(int, char)]]()

for i, (x, y) in XY.sorted():
  if not table.hasKey(y):
    table[y] = @[]
  table[y].add((x, S[i]))

# for x in table.pairs:
#   echo x

# if table.keys.toSeq.allIt(
#   table[it]
#     .mapIt(it[1])
#     .isSorted
# ):
#   echo "No"
# else:
#   echo "Yes"
