import sequtils, strutils, strformat, algorithm, math, sugar, hashes, tables
import complex, random, deques, heapqueue, sets, macros
{.warning[UnusedImport]: off.}

let input = iterator: string =
    while true:
        for w in stdin.readLine().split():
            yield w

const MOD = 998244353

let N = input().parseInt()

var cnt: array[1..9, int]
for j in 1..9:
    cnt[j] = 1

for i in 2..N:
    let bcnt = cnt
    for j in 1..9:
        cnt[j] = 0
    for j in 1..9:
        for d in -1..1:
            if j+d notin 1..9:
                continue
            cnt[j] += bcnt[j+d]
            cnt[j] = cnt[j] mod MOD
            # echo (j+d)
    # echo i, cnt

echo cnt.sum() mod MOD