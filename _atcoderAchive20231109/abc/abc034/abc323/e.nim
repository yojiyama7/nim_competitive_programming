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

const MOD* = 998244353
type ModInt* = object
  v*: int
proc initModInt(x: int): ModInt =
  result.v = ((x mod MOD) + MOD) mod MOD
proc `+`*(a, b: ModInt): ModInt =
  result.v = a.v + b.v
  if result.v >= MOD: result.v = result.v mod MOD
proc `*`*(a, b: ModInt): ModInt =
  result.v = a.v * b.v
  if result.v >= MOD: result.v = result.v mod MOD
proc `^`*(a: ModInt, b: int): ModInt =
  result.v = 1
  var p = b
  var mul = a
  while p > 0:
    if (p and 1) > 0: result = result * mul
    mul = mul * mul
    p = p shr 1

proc `+`*(a: ModInt, b: int): ModInt = a + b.initModInt
proc `+`*(a: int, b: ModInt): ModInt = a.initModInt + b
proc `-`*(a: ModInt, b: int): ModInt = a + -b
proc `-`*(a, b: ModInt): ModInt = a + -b.v
proc `-`*(a: int, b: ModInt): ModInt = -a + b
proc `*`*(a: ModInt, b: int): ModInt = a * b.initModInt
proc `*`*(a: int, b: ModInt): ModInt = a.initModInt * b
proc `/`*(a, b: ModInt): ModInt = a * b^(MOD-2)
proc `/`*(a: ModInt, b: int): ModInt = a * b.initModInt^(MOD-2)
proc `+=`*(a: var ModInt, b: int) = a = a + b
proc `+=`*(a: var ModInt, b: ModInt) = a = a + b
proc `-=`*(a: var ModInt, b: int) = a = a - b
proc `-=`*(a: var ModInt, b: ModInt) = a = a - b
proc `*=`*(a: var ModInt, b: int) = a = a * b
proc `*=`*(a: var ModInt, b: ModInt) = a = a * b
proc `/=`*(a: var ModInt, b: int) = a = a / b
proc `/=`*(a: var ModInt, b: ModInt) = a = a / b
proc `$`*(a: ModInt): string = $a.v
proc `~`*(a: ModInt): ModInt = 1.initModInt / a

let 
  (N, X) = stdin.readline.split.map(parseInt).toTuple(2)
  T = stdin.readLine.split.map(parseInt)
# let 
#   (N, X) = (2, 1000)
#   T = @[10000, 10000]


let oneDivN = (initModInt(1) / initModInt(N))

# i秒時点で曲がちょうどな確率
var dp = newSeqWith(X+1, initModInt(0))
dp[0] = initModInt(1)
for i in 1..X:
  for t in T:
    if i-t >= 0:
      dp[i] += dp[i-t] * oneDivN

var result = initModInt(0)
for i in 0..<T[0]:
  if X-i >= 0:
    result += dp[X-i] * oneDivN
echo result
