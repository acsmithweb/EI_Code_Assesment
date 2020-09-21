class ConfigParserService

  def initialize(filename)
    @filename = filename
    @config_hash = {}
    @parser_utility = ParserUtilities.new
  end

  def execute
    parse_file
    return @config_hash
  end

  private

  def parse_file
    File.foreach(@filename) do |line|
      parse_line(line)
    end
  end

  def parse_line(line)
    if !(@parser_utility.empty_line?(line))
      line = @parser_utility.remove_space(line)
      if !@parser_utility.commented_line?(line[0])
          @key_value_array = @parser_utility.split_line(line)
          parse_for_boolean
          parse_for_numerics
          add_properties_to_hash
      end
    end
  end

  def parse_for_boolean
    if @parser_utility.boolean_value?(@key_value_array[1])
      @key_value_array[1] = @parser_utility.to_boolean_value(@key_value_array[1])
    end
  end

  def parse_for_numerics
    if @parser_utility.numeric_value?(@key_value_array[1])
      @key_value_array[1] = @parser_utility.to_numeric_value(@key_value_array[1])
    end
  end

  def add_properties_to_hash
    @config_hash[@key_value_array[0]] = @key_value_array[1]
  end
end

class ParserUtilities
  def split_line(line)
    split_line = line.strip.split('=')
    return split_line.count() == 2 ? split_line : invalid_config
  end

  def commented_line?(character)
    return character == '#'
  end

  def remove_space(line)
    return line.delete(' ')
  end

  def empty_line?(line)
    return line.strip.empty?
  end

  def boolean_value?(value)
    case value.downcase
    when "yes","no","on","off","true","false"
      return true
    else
      return false
    end
  end

  def to_boolean_value(value)
    case value.strip.downcase
    when "yes","on","true"
      return true
    when "no","off","false"
      return false
    else
      raise StandardError.new "Invalid Boolean Value"
    end
  end

  def numeric_value?(value)
    return true if Float(value) rescue false
  end

  def value_is_integer?(value)
    return value.to_s == value.to_s.to_i.to_s
  end

  def value_is_float?(value)
    return value.to_s == value.to_s.to_f.to_s
  end

  def to_numeric_value(value)
    return value.to_s.to_i if value_is_integer?(value)
    return value.to_s.to_f if value_is_float?(value)
    value
  end

  def invalid_config
    raise StandardError.new 'Invalid Config Line'
  end
end

filename = ARGV[0]
parser_service = ConfigParserService.new(filename)
puts parser_service.execute
