class Inputs
  class << self
    def generate(inputs)
      %w[0 1].repeated_permutation(inputs.size).map { |values| inputs.zip(values).to_h }
    end
  end
end
