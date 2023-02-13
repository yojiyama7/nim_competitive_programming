from urlToDir import solve

for i in range(1, 290):
    url = f"https://atcoder.jp/contests/abc{i:0>3}"
    solve(url)
