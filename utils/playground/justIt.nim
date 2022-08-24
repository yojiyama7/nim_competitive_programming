import sugar
import strutils
import sequtils
import macros

proc just[T, U](x: T, f: T -> U): U =
  return f(x)

let a = stdin.readLine.split.just(it => (it[0], it[1 .. ^1]))
echo a

## want to
## でもこれsplit()とsplit.()を分けるのが難しいので
## justを挟むのが良い実装な気がしてきた
# let a = stdin.readLine.split.(a => (a[0], a[1 .. ^1]))
# echo a
