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

let S = stdin.readLine
# let n = 300000
# let S = '('.repeat(n div 2) & ')'.repeat(n div 2)

proc solve(): string =
  var
    (l, r) = (0, S.len)
  var chars = initHashSet[char]()
  while r - l > 0:
    chars.clear()
    while r - l > 0 and S[l].isAlphaAscii():
      if S[l] in chars:
        # echo (S[l], chars)
        return "No"
      chars.incl(S[l])
      l += 1
    while r - l > 0 and S[r-1].isAlphaAscii():
      if S[r-1] in chars:
        # echo (S[r-1], chars)
        return "No"
      chars.incl(S[r-1])
      r -= 1
    l += 1
    r -= 1
  return "Yes"

echo solve()

