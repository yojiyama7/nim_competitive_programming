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

const dir_lables = "RULD"
const dir_cands = @[(1, 0), (0, -1), (-1, 0), (0, 1)]
const INF = 10^18

# var m = newTable[(int, int, int), int]()
var m = newSeqWith(H, newSeqWith(W, newSeqWith(4, INF)))
# var before = newTable[(int, int, int), (int, int, int)]()
var before = newSeqWith(H, newSeqWith(W, newSeqWith(4, (-1, -1, -1))))
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
  for di in dirs:
    let (dx, dy) = dir_cands[di]
    let (x, y) = (tx+dx, ty+dy)
    if not (x in 0..<W and y in 0..<H):
      continue
    if S[y][x] == '#':
      continue
    if m[y][x][di] != INF:
      continue
    # echo (x, y, dir_lables[di])
    m[y][x][di] = m[ty][tx][tdir] + 1
    before[y][x][di] = (tx, ty, tdir)
    # echo before[y][x][di]
    stack.add((x, y, di))

# for y in 0..<H:
#   var words = newSeq[string]()
#   for x in 0..<W:
#     var a = "...."
#     for k in 0..<4:
#       if m[y][x][k] != INF:
#         a[k] = ">^<V"[k]
#         # assert((x, y) == (sx, sy) or before[y][x][k] != (-1, -1, -1))
#     words.add a
#   echo words.join("|")

# echo before
let l = (0..<4).toSeq.filterIt(m[gy][gx][it] != INF)
if l.len == 0:
  echo "No"
  quit()
echo "Yes"
var (cx, cy, cdir) = (gx, gy, l[0])

var rev_res = ""
while (cx, cy) != (sx, sy):
  # echo (cx, cy, cdir), before[cy][cx][cdir]
  rev_res.add dir_lables[cdir]
  (cx, cy, cdir) = before[cy][cx][cdir]
echo rev_res.reversed.join()
