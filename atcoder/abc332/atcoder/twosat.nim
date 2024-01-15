when not declared ATCODER_TWOSAT_HPP:
  const ATCODER_TWOSAT_HPP* = 1

  import atcoder/internal_scc
  
  # Reference:
  # B. Aspvall, M. Plass, and R. Tarjan,
  # A Linear-Time Algorithm for Testing the Truth of Certain Quantified Boolean
  # Formulas
  type TwoSAT* = object
    n:int
    answer:seq[bool]
    scc:internal_scc_graph

  proc init_TwoSAT*(n:int):auto =
    TwoSAT(n:n, answer:newSeq[bool](n), scc:init_internal_scc_graph(2 * n))
  
  proc add_clause*(self:var TwoSAT, i:int, f:bool, j:int, g:bool) =
    assert i in 0..<self.n
    assert j in 0..<self.n
    self.scc.add_edge(2 * i + (if f: 0 else: 1), 2 * j + (if g: 1 else: 0))
    self.scc.add_edge(2 * j + (if g: 0 else: 1), 2 * i + (if f: 1 else: 0))
  proc satisfiable*(self:var TwoSAT):bool =
    let id = self.scc.scc_ids()[1]
    for i in 0..<self.n:
      if id[2 * i] == id[2 * i + 1]: return false
      self.answer[i] = id[2 * i] < id[2 * i + 1]
    return true
  proc answer*(self: TwoSAT):auto = self.answer
