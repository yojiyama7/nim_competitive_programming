import sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables
import complex, random, deques, heapqueue, sets, macros, typetraits
{. warning[UnusedImport]: off, hint[XDeclaredButNotUsed]: off .}

dumpTree:
  (let tmp = a; (tmp[0], tmp[1]))

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

# macro toTuple[T](a: openArray[T], s: static[string]): untyped =

# dumpTree:
echo stdin.readLine.split.toTuple(2)
# toTuple(stdin.readLine.split, (int, string))

# proc
# func
# method
# iterator

# template
# macro
