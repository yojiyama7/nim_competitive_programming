import macros

dumpTree:
  macro toTuple(lArg: openArray, n: static[int]): untyped =
    let l = genSym()
    var t = newNimNode(nnkTupleConstr)
    for i in 0..<n:
      t.add quote do:
        `l`[`i`]
    quote do:
      (let `l` = `lArg`; `t`)
