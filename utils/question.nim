import strutils
import sequtils

let N = 10
let S = "grape banana tomato"
let A = newSeqWith(N, S.split)
echo A
