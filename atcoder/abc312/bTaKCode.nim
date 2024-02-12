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

let 
  (N, M) = stdin.readLine.split.map(parseInt).toTuple(2)
  S = newSeqWith(N, stdin.readLine)

const TaKCode = """
###.?????
###.?????
###.?????
....?????
?????????
?????....
?????.###
?????.###
?????.###
""".strip.split("\n")

var
  leftTops = newSeqWith(0, (0, 0))
  rightBottoms = newSeqWith(0, (0, 0))

for cy in 0..<N-9+1:
  for cx in 0..<M-9+1:
    block validate:
      for dy in 0..<9:
        for dx in 0..<9:
          if TaKCode[dy][dx] == '?':
            continue
          if S[cy+dy][cx+dx] != TaKCode[dy][dx]:
            break validate
      echo &"{cy+1} {cx+1}"
      # ---
      # for dy in 0..<3:
      #   for dx in 0..<3:
      #     let (x, y) = (cx+dx, cy+dy)
      #     if S[x][y] != '#': break validate
      # for dy in 6..<9:
      #   for dx in 6..<9:
      #     let (x, y) = (cx+dx, cy+dy)
      #     if S[x][y] != '#': break validate
      # for i in 0..<3:
      #   let (x, y) = (cx+3, cy+i)
      #   if S[x][y] != '.': break validate
      # for i in 0..<4:
      #   let (x, y) = (cx+i, cy+3)
      #   if S[x][y] != '.': break validate
      # for i in 5..<9:
      #   let (x, y) = (cx+i, cy+5)
      #   if S[x][y] != '.': break validate
      # for i in 6..<9:
      #   let (x, y) = (cx+5, cy+i)
      #   if S[x][y] != '.': break validate
      # echo &"{x}"