when not declared ATCODER_FLOAT_UTILS_HPP:
  const ATCODER_FLOAT_UTILS_HPP* = 1
  import std/math as math_lib_floatutils, std/strutils
  import atcoder/element_concepts
  import atcoder/extra/other/static_var

  #import atcoder/extra/math/longdouble
  proc getParameters*(Real: typedesc): ptr[tuple[n: int, pi, eps, inf: Real]] =
    var p {.global.}: tuple[n: int, pi, eps, inf: Real]
    return p.addr

  converter floatConverter*(a: SomeInteger): float = a.float
  converter float64Converter*(a: SomeInteger): float64 = a.float64
  converter float32Converter*(a: SomeInteger): float32 = a.float32
  converter floatConverter*(a: string): float = a.parseFloat
  converter float64Converter*(a: string): float64 = a.parseFloat.float64
  converter float32Converter*(a: string): float32 = a.parseFloat.float32

  staticVar FieldElem:
    pi: U.type
    eps: U.type
    inf: U.type

  #proc getPi*(Real:typedesc):Real = Real.getParameters()[].pi
  #proc getEPS*(Real:typedesc):Real = Real.getParameters()[].eps
  #proc getINF*(Real:typedesc):Real = Real.getParameters()[].inf
  #proc setEPS*(Real:typedesc, x:Real) = Real.getParameters()[].eps = x
  proc getPi*(Real: typedesc): Real = Real$.pi
  proc getEPS*(Real: typedesc): Real = Real$.eps
  proc getINF*(Real: typedesc): Real = Real$.inf
  proc setEPS*(Real: typedesc, x: Real) = Real$.eps = x


  proc valid_range*[Real](l, r: Real): bool =
    # assert(l <= r)
    var (l, r) = (l, r)
    if l > r: swap(l, r)
    let d = r - l
    let eps = Real.getEps()
    if d < eps: return true
    if l <= Real(0) and Real(0) <= r: return false
    return d < eps * min(abs(l), abs(r))

  proc machineEpsilon*(Real: typedesc): Real =
    let one = Real(1)
    var
      eps = one
    while not (one + eps == one):
      eps /= 2
    eps

  template initPrec*(Real: typedesc[typed]) =
    when Real is SomeFloat:
      Real$.inf = Real(Inf)
      Real$.pi = Real(PI)
    #elif Real is float128:
    #  Real$.inf = Real(1) / Real(0)
    #  Real$.pi = arctan(Real(1)) * Real(4)
    else:
      Real$.inf = Real(1) / Real(0)
      Real$.pi = pi()
    #echo machineEpsilon(Real)
    #Real$.eps = machineEpsilon(Real) * Real(10000)
    when Real is float | float64:
      Real$.eps = 1e-9
    elif Real is float32:
      Real$.eps = 1e-7
    else:
      block:
        let one = Real(1)
        var eps2 = one
        while not (one + eps2 == one):
          eps2 = eps2 / Real(2)
        Real$.eps = eps2 * Real(1000000)

    # TODO: relative error
    proc `=~`*(a, b: Real): bool = abs(a - b) < Real$.eps
    proc `!=~`*(a, b: Real): bool = abs(a - b) > Real$.eps
    proc `<~`*(a, b: Real): bool = a + Real$.eps < b
    proc `>~`*(a, b: Real): bool = a > b + Real$.eps
    proc `<=~`*(a, b: Real): bool = a < b + Real$.eps
    proc `>=~`*(a, b: Real): bool = a + Real$.eps > b

  # for OMC
  proc estimateRational*[Real](x: Real, n: int) =
    var m = Real$.inf
    var q = 1
    while q <= n:
      let p = round(x * q.Real)
      let d = abs(p / q.Real - x)
      if d < m:
        m = d
        echo "found: ", p, "/", q, "   ", "error: ", d
      q.inc
    return

  float.initPrec()
  #float64.initPrec()
  float32.initPrec()
  #float128.initPrec()
