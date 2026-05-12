import std/[sequtils, strutils, strformat, strscans, algorithm, math, sugar, hashes, tables, complex, random, deques, heapqueue, sets, macros, bitops]
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
iterator skipBy(r: HSlice, step: int): int =
  for i in countup(r.a, r.b, step):
    yield i
proc initHashSet[T](): Hashset[T] = initHashSet[T](0)

################################

let
  (H, W) = stdin.readLine.split.map(parseInt).toTuple(2)
  S = newSeqWith(H, stdin.readLine)

var sx, sy, gx, gy = -1
for y in 0..<H:
  for x in 0..<W:
    if S[y][x] == 'S':
      (sx, sy) = (x, y)
    if S[y][x] == 'G':
      (gx, gy) = (x, y)

const dir_cands = @[(1, 0), (0, -1), (-1, 0), (0, 1)]
const INF = 10^18

var m = newSeqWith(H, newSeqWith(W, newSeqWith(4, INF)))
var stack = @[(sx, sy, 0)]
m[sy][sx][0] = 0
while stack.len > 0:
  let (tx, ty, tdir) = stack.pop()
  let t = S[ty][tx]
  var dirs = initHashSet[int]()
  if t == 'o':
    dirs.incl(tdir)
  elif t == 'x':
    dirs = (0..<4).toSeq.toHashSet()
    dirs.excl(tdir)
  else:
    dirs = (0..<4).toSeq.toHashSet()
  # echo dirs
  for di in dirs:
    let (dx, dy) = dir_cands[di]
    let (x, y) = (tx+dx, ty+dy)
    if not (x in 0..<W and y in 0..<H):
      continue
    if m[y][x][di] != INF:
      continue
    if S[y][x] == '#':
      continue
    m[y][x][di] = m[ty][tx][tdir] + 1
    stack.add((x, y, di))

# for mi in m:
#   var lines = newSeq[string]()
#   for scores in mi:
#     var a = ""
#     for k, s in scores:
#       if s == INF:
#         a.add '.'
#       else:
#         a.add "^<V>"[k]
#     lines.add a
#   echo lines.join("|")

var (cx, cy) = (gx, gy)
var rev_res = ""
var remain = m[cy][cx].min()
while (cx, cy) != (sx, sy):
  var could_move = false
  for di in 0..<4:
    let (dx, dy) = dir_cands[(di + 2) mod 4]
    let (x, y) = (cx+dx, cy+dy)
    if not (x in 0..<W and y in 0..<H): continue
    if m[cy][cx][di] == INF: continue
    if (0..<4).anyIt( m[y][x][it] + 1 == remain ):
      (cx, cy) = (x, y)
      rev_res.add "RULD"[di]
      remain -= 1
      could_move = true
      break
  if not could_move:
    echo "No"
    quit()

echo "Yes"
echo rev_res.reversed.join("")