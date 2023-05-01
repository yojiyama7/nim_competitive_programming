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

let
  (N, M) = stdin.readLine.split.map(parseInt).toTuple(2)
  UV = newSeqWith(M, stdin.readLine.split.map(parseInt).toTuple(2))

proc solve(): string =
  var g = initTable[int, HashSet[int]]()
  for (u, v) in UV:
    if u notin g:
      g[u] = initHashSet[int]()
    if v notin g:
      g[v] = initHashSet[int]()
    g[u].incl(v)
    g[v].incl(u)

  let ct = (g.values).toSeq.mapIt(it.len).toCountTable()
  # echo ct
  if not(1 in ct and ct[1] == 2):
    return "No"
  elif not(2 in ct):
    return "No"
  elif ct.len > 2:
    return "No"
  return "Yes"

echo solve()

