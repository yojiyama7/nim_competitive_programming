import sequtils, bitops

let A = (0..<4).toSeq
let N = A.len  # 要素数

# Aの各要素について選ぶ、選ばないを決めた時にあり得るパターンを列挙
for i in 0..<(1 shl N):
  var selectedElements = newSeq[int]()
  for j in 0..<N:
    if i.testBit(j): # ここで使っている
      selectedElements.add(A[j])
  echo selectedElements
