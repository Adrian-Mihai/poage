class LogicGates
  class << self
    def truth_table
      {
        NOT: {
          '0': 'A',
          '1': "A'"
        },
        AND: {
          '0': "A' + B'",
          '1': 'A ⋅ B'
        },
        OR: {
          '0': "A' ⋅ B'",
          '1': 'A + B'
        },
        NAND: {
          '0': 'A ⋅ B',
          '1': "A' + B'"
        },
        NOR: {
          '0': 'A + B',
          '1': "A' ⋅ B'"
        }
      }
    end
  end
end
