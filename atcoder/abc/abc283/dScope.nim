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

proc solve(): string =
  var
    starts = newSeq[int]()
    chars = initHashSet[char]()
    (rl, rr) = (-1, -1)
  for i, c in S:
    # echo (i, c)
    if c == '(':
      starts.add(i)
    elif c == ')':
      let (l, r) = (starts.pop(), i)
      if rl == -1:
        for j in l+1..<r:
          chars.excl(S[j])
      else:
        for j in l+1..<rl:
          chars.excl(S[j])
        for j in rr+1..<r:
          chars.excl(S[j])
      (rl, rr) = (l, r)
    elif c in chars:
      # echo (chars, )
      return "No"
    else:
      chars.incl(c)
  return "Yes"

echo solve()
