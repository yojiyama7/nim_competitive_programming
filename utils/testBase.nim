# var n: int

# # text
# let A = stdin.readLine
# echo A

# # int
# let B = stdin.readLine.parseInt
# echo B

# # texts
# let C = stdin.readLine.split
# echo C

# # ints
# let D = stdin.readLine.split.map(parseInt)
# echo D

# # textList
# n = stdin.readLine.parseInt
# let E = newSeqWith(n, stdin.readLine)
# echo E

# # intList
# n = stdin.readLine.parseInt
# let F = newSeqWith(n, stdin.readLine.parseInt)
# echo F

# # textsList
# n = stdin.readLine.parseInt
# let G = newSeqWith(n, stdin.readLine.split)
# echo G

# # intsList
# n = stdin.readLine.parseInt
# let H = newSeqWith(n, stdin.readLine.split.map(parseInt))
# echo H

# # fixedLengthTexts
# let (I, J) = stdin.readLine.split.toTuple(2)
# echo I
# echo J

# # fixedLengthInts
# let (K, L) = stdin.readLine.split.map(parseInt).toTuple(2)
# echo K
# echo L

# # fixedLengthValues
# let (M, N) = stdin.readLine.split.just(it => (it[0], it[1].parseInt))
# echo M
# echo N

# # fixedLengthValuesList
# n = stdin.readLine.parseInt
# let O = newSeqWith(n, stdin.readLine.split.just(it => (it[0], it[1].parseInt)))
# echo O
