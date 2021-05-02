class BooleanAlgebra
  class << self
    def apply(right_argument, left_argument)
      right_arguments = right_argument.split(' + ')
      left_arguments = left_argument.split(' + ')
      return "#{right_arguments.first} ⋅ #{left_arguments.first}" if one_argument?(right_arguments, left_arguments)

      expression = ''
      right_arguments.each do |r_argument|
        left_arguments.each do |l_argument|
          expression << r_argument + ' ⋅ ' + l_argument + ' + '
        end
      end
      expression.delete_suffix(' + ')
    end

    private

    def one_argument?(right_arguments, left_arguments)
      right_arguments.size == 1 && left_arguments.size == 1
    end
  end
end
