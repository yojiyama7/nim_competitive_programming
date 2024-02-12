import sequtils, strutils, strformat, algorithm, math, sugar, hashes, tables
import complex, random, deques, heapqueue, sets, macros
{.warning[UnusedImport]: off.}

let input = iterator: string =
    while true:
        for w in stdin.readLine().split():
            yield w

let S = input()

echo S.toSeq.sorted().join()
