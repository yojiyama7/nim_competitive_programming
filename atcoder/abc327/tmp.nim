# import math
# {.nanChecks: on, infChecks: on.}

{.checks: on.}
{.floatChecks: on.}

echo "int"
echo int.low / 0 # floatChecks
echo -3/0
echo 0/0
echo 4/0
echo int.high / 0 # floatChecks
echo "---"

echo "float"
echo -Inf / 0
# echo float.low / 0 # floatChecks
echo -4.4 / 0
echo 0.0 / 0
echo 5.3 / 0
# echo float.high / 0 # floatChecks
echo Inf / 0
echo "NaN: ", NaN / 0

# echo 1.0 / 0
# echo 1 / 0
# echo 14213 / 0

# # echo 2^64
# try:
#   discard 111 / 0
#   discard 22.2 / 0
#   # discard [1, 2, 3][10]
# except ArithmeticDefect:
#   echo "dddddd"
