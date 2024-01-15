when not declared ATCODER_INTERNAL_MATH_HPP:
  const ATCODER_INTERNAL_MATH_HPP* = 1
  import std/math

  # Fast moduler by barrett reduction
  # Reference: https:#en.wikipedia.org/wiki/Barrett_reduction
  # NOTE: reconsider after Ice Lake
  type Barrett* = object
    m*, im*:uint

  # @param m `1 <= m`
  proc initBarrett*(m:uint):auto = Barrett(m:m, im:cast[uint](-1) div m + 1)

  # @return m
  proc umod*(self: Barrett):uint =
    self.m

  {.emit: """
#include<cstdio>
inline unsigned long long calc_mul(const unsigned long long &a, const unsigned long long &b){
  return (unsigned long long)(((unsigned __int128)(a)*b) >> 64);
}
""".}
  proc calc_mul*(a,b:culonglong):culonglong {.importcpp: "calc_mul(#,#)", nodecl, inline.}
  # @param a `0 <= a < m`
  # @param b `0 <= b < m`
  # @return `a * b % m`
  proc quo*(self: Barrett, n:int | uint):int =
    let n = n.uint
    let x = calc_mul(n.culonglong, self.im.culonglong).uint
    let r = n - x * self.m
    return int(if self.m <= r: x - 1 else: x)
  proc rem*(self: Barrett, n:int | uint):int =
    let n = n.uint
    let x = calc_mul(n.culonglong, self.im.culonglong).uint
    let r = n - x * self.m
    return int(if self.m <= r: r + self.m else: r)
  proc quorem*(self: Barrett, n:int | uint):(int, int) =
    let n = n.uint
    let x = calc_mul(n.culonglong, self.im.culonglong).uint
    let r = n - x * self.m
    return if self.m <= r: (int(x - 1), int(r + self.m)) else: (int(x), int(r))

  proc pow*(self: Barrett, n:uint | int, p:int):int =
    var
      a = self.rem(n)
      r:uint = if self.m == 1: 0 else: 1
      p = p
    while p > 0:
      if (p and 1) != 0: r = self.mul(r, a.uint)
      a = self.mul(a.uint, a.uint).int
      p = p shr 1
    return int(r)

  proc mul*(self: Barrett, a:uint, b:uint):uint {.inline.} =
    # [1] m = 1
    # a = b = im = 0, so okay

    # [2] m >= 2
    # im = ceil(2^64 / m)
    # -> im * m = 2^64 + r (0 <= r < m)
    # let z = a*b = c*m + d (0 <= c, d < m)
    # a*b * im = (c*m + d) * im = c*(im*m) + d*im = c*2^64 + c*r + d*im
    # c*r + d*im < m * m + m * im < m * m + 2^64 + m <= 2^64 + m * (m + 1) < 2^64 * 2
    # ((ab * im) >> 64) == c or c + 1
    let z = a * b
    #  #ifdef _MSC_VER
    #      unsigned long long x;
    #      _umul128(z, im, &x);
    #  #else
    ##TODO
    #      unsigned long long x =
    #        (unsigned long long)(((unsigned __int128)(z)*im) >> 64);
    #  #endif
    #let x = calc_mul(z.culonglong, self.im.culonglong).uint
    #result = z - x * self.m
    #if self.m <= result: result += self.m
    return self.rem(z).uint

  # @param n `0 <= n`
  # @param m `1 <= m`
  # @return `(x ** n) % m`
  proc pow_mod_constexpr*(x, n, m:int):int =
    if m == 1: return 0
    var
      r = 1
      y = floorMod(x, m)
      n = n
    while n != 0:
      if (n and 1) != 0: r = (r * y) mod m
      y = (y * y) mod m
      n = n shr 1
    return r.int
  
  # Reference:
  # M. Forisek and J. Jancina,
  # Fast Primality Testing for Integers That Fit into a Machine Word
  # @param n `0 <= n`
  proc is_prime_constexpr*(n:int):bool =
    if n <= 1: return false
    if n == 2 or n == 7 or n == 61: return true
    if n mod 2 == 0: return false
    var d = n - 1
    while d mod 2 == 0: d = d div 2
    for a in [2, 7, 61]:
      var
        t = d
        y = pow_mod_constexpr(a, t, n)
      while t != n - 1 and y != 1 and y != n - 1:
        y = y * y mod n
        t =  t shl 1
      if y != n - 1 and t mod 2 == 0:
        return false
    return true
  proc is_prime*[n:static[int]]():bool = is_prime_constexpr(n)
#  
#  # @param b `1 <= b`
#  # @return pair(g, x) s.t. g = gcd(a, b), xa = g (mod b), 0 <= x < b/g
  proc inv_gcd*(a, b:int):(int,int) =
    var a = floorMod(a, b)
    if a == 0: return (b, 0)
  
    # Contracts:
    # [1] s - m0 * a = 0 (mod b)
    # [2] t - m1 * a = 0 (mod b)
    # [3] s * |m1| + t * |m0| <= b
    var
      s = b
      t = a
      m0 = 0
      m1 = 1
  
    while t != 0:
      var u = s div t
      s -= t * u;
      m0 -= m1 * u;  # |m1 * u| <= |m1| * s <= b
  
      # [3]:
      # (s - t * u) * |m1| + t * |m0 - m1 * u|
      # <= s * |m1| - t * u * |m1| + t * (|m0| + |m1| * u)
      # = s * |m1| + t * |m0| <= b
  
      var tmp = s
      s = t;t = tmp;
      tmp = m0;m0 = m1;m1 = tmp;
    # by [3]: |m0| <= b/g
    # by g != b: |m0| < b/g
    if m0 < 0: m0 += b div s
    return (s, m0)

  # Compile time primitive root
  # @param m must be prime
  # @return primitive root (and minimum in now)
  proc primitive_root_constexpr*(m:int):int =
    if m == 2: return 1
    if m == 167772161: return 3
    if m == 469762049: return 3
    if m == 754974721: return 11
    if m == 998244353: return 3
    var divs:array[20, int]
    divs[0] = 2
    var cnt = 1
    var x = (m - 1) div 2
    while x mod 2 == 0: x = x div 2
    var i = 3
    while i * i <= x:
      if x mod i == 0:
        divs[cnt] = i
        cnt.inc
        while x mod i == 0:
          x = x div i
      i += 2
    if x > 1:
      divs[cnt] = x
      cnt.inc
    var g = 2
    while true:
      var ok = true
      for i in 0..<cnt:
        if pow_mod_constexpr(g, (m - 1) div divs[i], m) == 1:
          ok = false
          break
      if ok: return g
      g.inc
  proc primitive_root*[m:static[int]]():auto =
    primitive_root_constexpr(m)

  # @param n `n < 2^32`
  # @param m `1 <= m < 2^32`
  # @return sum_{i=0}^{n-1} floor((ai + b) / m) (mod 2^64)
  proc floor_sum_unsigned*(n, m, a, b:uint):uint =
    result = 0
    var (n, m, a, b) = (n, m, a, b)
    while true:
      if a >= m:
        result += n * (n - 1) div 2 * (a div m)
        a = a mod m
      if b >= m:
        result += n * (b div m)
        b = b mod m

      let y_max = a * n + b
      if y_max < m: break
      # y_max < m * (n + 1)
      # floor(y_max / m) <= n
      n = y_max div m
      b = y_max mod m
      swap(m, a)
