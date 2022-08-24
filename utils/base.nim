import sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables
import complex, random, deques, heapqueue, sets, macros
{. warning[UnusedImport]: off, hint[XDeclaredButNotUsed]: off .}

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

################################

# proc input(): string =
#   stdin.readLine
# proc inputs(): seq[string] =
#   stdin.readline.split
# proc inputInt(): int =
#   stdin.readLine.parseInt
# proc inputInts(): seq[int] =
#   stdin.readLine.split.map(parseInt)
# proc inputValues(s: string): tuple =
#   stdin.readLine.scanTuple(s)

var n: int

# text
let A = stdin.readLine
echo A

# int
let B = stdin.readLine.parseInt
echo B

# texts
let C = stdin.readLine.split
echo C

# ints
let D = stdin.readLine.split.map(parseInt)
echo D

# textList
n = stdin.readLine.parseInt
let E = newSeqWith(n, stdin.readLine)
echo E

# intList
n = stdin.readLine.parseInt
let F = newSeqWith(n, stdin.readLine.parseInt)
echo F

# textsList
n = stdin.readLine.parseInt
let G = newSeqWith(n, stdin.readLine.split)
echo G

# intsList
n = stdin.readLine.parseInt
let H = newSeqWith(n, stdin.readLine.split.map(parseInt))
echo H

# fixedLengthTexts
let (I, J) = stdin.readLine.split.toTuple(2)
echo I
echo J

# fixedLengthInts
let (K, L) = stdin.readLine.split.map(parseInt).toTuple(2)
echo K
echo L

# fixedLengthValues
let (M, N) = stdin.readLine.split.just(it => (it[0], it[1].parseInt))
echo M
echo N

# fixedLengthValuesList
n = stdin.readLine.parseInt
let O = newSeqWith(n, stdin.readLine.split.just(it => (it[0], it[1].parseInt)))
echo O
