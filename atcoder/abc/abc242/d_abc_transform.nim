import sequtils, strutils, strformat, algorithm, math, sugar, hashes, tables
import complex, random, deques, heapqueue, sets, macros
{.warning[UnusedImport]: off.}

let input = iterator: string =
    while true:
        for w in stdin.readLine().split():
            yield w

let S = input()
let Q = input().parseInt()
let TK = newSeqWith(Q, stdin.readLine.split().toSeq().map(parseInt))
# var S = newString(10^5)
# for i in 0..<10^5:
#     S[i] = "ABC"[i mod 3]
# let Q = 10^5
# let TK = newSeqWith(Q, newSeqWith(2, 10))
# echo TK
const Aint64 = 'A'.int64

proc toNum(c: char): int64 =
    return c.int64 - Aint64

proc solve(t: int64, k: int64): int64 =
    # echo t, k
    if t == 0:
        return S[k].toNum()
    if k == 0:
        return (S[0].toNum() + t) mod 3
    return (solve(t-1, k div 2) + 1 + (k mod 2)) mod 3

for x in TK:
    let (t, k) = (x[0], x[1]-1)
    echo "ABC"[solve(t, k)]
