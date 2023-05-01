import strutils, sequtils, macros
{. warning[UnusedImport]: off, hint[XDeclaredButNotUsed]: off, hint[Name]: off .}

macro toTuple(lArg: openArray, n: static[int]): untyped =
  let l = genSym()
  var t = newNimNode(nnkTupleConstr)
  for i in 0..<n:
    t.add quote do:
      `l`[`i`]
  quote do:
    (let `l` = `lArg`; `t`)

################################

let
  (N, M) = stdin.readLine.split.map(parseInt).toTuple(2)
  A = stdin.readLine.split.map(parseInt)

var result = newSeq[int]()
var i = 1
while i <= N:
  var start = i
  while i <= N and (i in A):
    i.inc()
  for x in countdown(i, start):
    result.add(x)
  i.inc()
echo result.join(" ")
