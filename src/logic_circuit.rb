require 'English'

class LogicCircuit
  FILENAME = 'in.txt'.freeze

  attr_reader :circuit, :errors

  def initialize(path = FILENAME)
    @path    = path
    @circuit = {}
    @errors  = []
    read
  end

  def valid?
    @errors.empty?
  end

  private

  def read
    return @errors << 'No such file' unless File.exist?(@path)
    return @errors << 'The file is a directory' if File.directory?(@path)

    File.foreach(@path) do |line|
      next if line.strip.empty?

      parsed_line = line.strip.split('=')
      next @errors << "Line: #{$INPUT_LINE_NUMBER} Invalid format" unless parsed_line.size == 2

      @circuit[parsed_line.first.to_sym] = parsed_line.last
    end
  end
end
