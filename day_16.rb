class Packet
  attr_accessor :version
  attr_accessor :type_id
  attr_accessor :subpackets
  attr_accessor :literal

  def initialize(in_version, in_type_id)
    @version = in_version
    @type_id = in_type_id
    @literal = 0
    @subpackets = []
  end

  def is_operator_packet?
    @type_id != 4
  end

  def show_info
    puts "-" * 10
    puts "version: #{@version}"
    puts "type_id: #{@type_id}"
    puts "literal: #{@literal}"
    puts "-" * 10
  end

  def sum_versions
    @version + @subpackets.collect { |c| c.sum_versions }.sum
  end

  def calculate_value
    case @type_id
    when 0
      @subpackets.collect { |c| c.calculate_value }.sum 
    when 1
      @subpackets.collect { |c| c.calculate_value }.inject(:*)
    when 2
      @subpackets.collect { |c| c.calculate_value }.min
    when 3
      @subpackets.collect { |c| c.calculate_value }.max
    when 4
      @literal
    when 5
      (@subpackets[0].calculate_value > @subpackets[1].calculate_value ? 1 : 0)
    when 6
      (@subpackets[0].calculate_value < @subpackets[1].calculate_value ? 1 : 0)
    when 7
      (@subpackets[0].calculate_value == @subpackets[1].calculate_value ? 1 : 0)
    end
  end
end

def parse_literal(in_string)
  the_step = 0
  the_bin_digit = ""
  loop do
    the_group = in_string[the_step..(the_step + 5 - 1)]
    the_bin_digit += the_group[1..-1]
    the_step += 5
    break if the_group[0] == "0"
  end
  literal = the_bin_digit.to_i(2)
  return literal, the_step
end

def parse(in_string)
  the_start = 0
  version = in_string[the_start..(the_start + 3 - 1)].to_i(2)
  the_start += 3
  packet_type_id = in_string[the_start..(the_start + 3 - 1)].to_i(2)
  the_start += 3

  p = Packet.new(version, packet_type_id)

  if !p.is_operator_packet?
    p.literal, the_num_read = parse_literal(in_string[the_start..-1])
    return p, the_start + the_num_read
  else
    # read all the sub packets
    length_type = in_string[the_start].to_i(2)
    the_start += 1
    if length_type == 0
      num_length_bits = 15
      sub_packet_bit_length = in_string[the_start..(the_start + num_length_bits - 1)].to_i(2)
      the_start += num_length_bits

      the_end = the_start + sub_packet_bit_length
      while the_start <  the_end
        sub_packet, the_num_read = parse(in_string[the_start..(the_end - 1)])
        p.subpackets << sub_packet
        the_start += the_num_read
      end
    else
      num_length_bits = 11
      num_subpackets = in_string[the_start..(the_start + num_length_bits - 1)].to_i(2)
      the_start += num_length_bits

      num_subpackets.times do |sp|
        sub_packet, the_num_read = parse(in_string[the_start..-1])
        p.subpackets << sub_packet
        the_start += the_num_read
      end
    end
  end
  return p, the_start
end

the_line = File.read('day_16_input.txt').strip

the_bin_line = the_line.to_i(16).to_s(2)
the_wanted_length = the_line.size * 4
while the_bin_line.size < the_wanted_length
  the_bin_line = "0" + the_bin_line
end

root_packet, n = parse(the_bin_line)
puts root_packet.sum_versions
puts root_packet.calculate_value
