import sequtils

iterator step(r: HSlice, s: int): int =
  if s == 0:
    discard
  if s > 0:
    for x in countup(r.a, r.b, s.abs):
      yield x
  else:
    for x in countdown(r.a, r.b, s.abs):
      yield x

# for i in (1..10).step(2):
#   echo i

echo (1..10).type
echo toSeq((1..10).step(2))
echo (10..1).step(-3).toSeq()
