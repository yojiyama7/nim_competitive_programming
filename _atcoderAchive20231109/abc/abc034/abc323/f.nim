import std/[sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables, complex, random, deques, heapqueue, sets, macros]
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

################################

let (AX, AY, BX, BY, CX, CY) = stdin.readLine.split.map(parseInt).toTuple(6)
let 
  A = (AX, AY)
  B = (BX, BY)
  C = (CX, CY)

proc dist(p: (int, int), q: (int, int)): int =
  let
    (x1, y1) = p
    (x2, y2) = q
  return abs(x1-x2) + abs(y1-y2)

let vDir =  if BY <= CY:
              1
            else:
              -1
let hDir =  if BX <= CX:
              1
            else:
              -1

var ans = 0
# v first
# A to nearB
ans += dist(A, (BX, BY-vDir))
## 障害物があれば
if (AX == BX and BX == CX) and ((AY <= BY and BY <= BY-vDir) or (BY-vDir <= BY and BY <= AY)):
  ans += 2
# 荷物運び直進only
if BX == CX:
  ans += dist(B, C)
# 荷物運び曲がる
else:
  ans += dist(B, C) + 2

var result = ans

ans = 0
# h first
# A to nearB
ans += dist(A, (BX-hDir, BY))
## 障害物があれば
if (AY == BY and BY == CY) and ((AX <= BX and BX <= BX-hDir) or (BX-hDir <= BX and BX <= AX)):
  ans += 2
# 荷物運び直進only
if BY == CY:
  ans += dist(B, C)
# 荷物運び曲がる
else:
  ans += dist(B, C) + 2

result = min(result, ans)

echo result