from collections import Counter

H, W = map(int, input().split())
S = [input() for i in range(H)]
T = [input() for i in range(H)]

if Counter(zip(*S)) == Counter(zip(*T)):
    print("Yes")
else:
    print("No")
