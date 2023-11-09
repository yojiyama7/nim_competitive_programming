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

proc unzip*[S, T](s: openArray[(S, T)]): (seq[S], seq[T]) =
  result[0] = newSeq[S](s.len)
  result[1] = newSeq[T](s.len)
  for i in 0..<s.len:
    result[0][i] = s[i][0]
    result[1][i] = s[i][1]

################################

let
  N = stdin.readLine.parseInt
  ST = newSeqWith(N, stdin.readLine.split.toTuple(2))

let
  (S, T) = unzip(ST)
var
  wordCountTable = (S & T).toCountTable

# echo wordCountTable
# echo wordCountTable["tanaka"]

for (s, t) in ST:
  wordCountTable[s] = wordCountTable[s] - 1 # QUESTION: なぜ -= と書けないのか
  wordCountTable[t] = wordCountTable[t] - 1

  if wordCountTable[s] > 0 and wordCountTable[t] > 0:
    echo "No"
    quit()

  wordCountTable[s] = wordCountTable[s] + 1
  wordCountTable[t] = wordCountTable[t] + 1

echo "Yes"
