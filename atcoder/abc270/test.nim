proc `//`(a: int, b: int): int =
  a div b
proc `//=`(a: var int, b: int): void =
  a = a // b
proc `mod=`(a: var int, b: int): void =
  a = a mod b

var a = 10
# a //= +4
a.mod= 6
echo a

proc myAdd[T](a: T, b: T): int =
  return a + b

echo 1.myAdd[:int](3)

