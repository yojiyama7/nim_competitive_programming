import sequtils, strutils, strformat, algorithm, math, sugar, hashes, tables
import complex, random, deques, heapqueue, sets, macros
{.warning[UnusedImport]: off.}

let input = iterator: string =
    while true:
        for w in stdin.readLine().split():
            yield w

# let (A, B, C, X) = stdin.readline().split().map(parseInt).toTuple(4)
let A, B, C, X = input().parseInt()

if X <= A:
    echo 1
elif X > B:
    echo 0
else:
    echo float(C)/float(B-A)
