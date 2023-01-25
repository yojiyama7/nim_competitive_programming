import tables

var a = initCountTable[char]()

echo a

a['r'] = 1
echo a

a['r'] += 1
echo a

var b = initTable[char, int]()

b['a'] = 10
echo b

b['a'] -= 1
echo b