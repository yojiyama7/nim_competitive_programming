import tables
import sequtils

let a = newTable[int, int]()
a[1] = 2
a[2] = 3
a[3] = 4

echo a
for x in a.keys: echo x
for x in a.values: echo x
echo toSeq(a.keys)

# echo a.keys.items.toSeq

## why can't (in 1.0.6 (atcoder version))
## 逆に1.6.6だとできるのはなぜ?
# echo a.keys.toSeq
