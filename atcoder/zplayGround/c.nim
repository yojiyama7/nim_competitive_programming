import strutils, sequtils
import atcoder/extra/structure/set_map

let Q = stdin.readLine.parseInt()
var T = newSeqUninitialized[int](Q)
var X = newSeqUninitialized[int](Q)
for i in 0..<Q:
  (T[i],X[i]) = stdin.readLine.split.map(parseInt)
var S = initSortedSet[int](true)
var res = newSeqOfCap[int](Q)
for i in 0..<Q:
  if T[i] == 1:
    S.incl(X[i])
  else:
    let te1 = S{X[i]-1}
    res.add(*te1)
    S.excl(te1)
echo res.join("\n")
