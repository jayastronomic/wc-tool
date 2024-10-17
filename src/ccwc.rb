class CCWC 
  @@file_paths = []
  @@options_hash = {
    "l" => false,
    "w" => false,
    "c" => false,
    "m" => false
  }
  @@total_line_count = 0 
  @@total_word_count = 0
  @@total_byte_count = 0

  def initialize(args)
    CCWC.parse(args)
  end

  def compute
    if no_options?
      @@file_paths.each_with_index do |file_path, i|
        line_count = get_line_count(file_path)
        @@total_line_count += line_count
        word_count = get_word_count(file_path)
        @@total_word_count += word_count
        byte_count = get_byte_count(file_path) 
        @@total_byte_count += byte_count
        puts "#{line_count}   #{word_count}  #{byte_count} #{file_path}"
      end 
      show_total?
    else
      @@file_paths.each_with_index do |file_path, i|
        line_count = @@options_hash["l"] ? get_line_count(file_path) : nil
        @@options_hash["l"] ? @@total_line_count += line_count : nil
        word_count = @@options_hash["w"] ? get_word_count(file_path) : nil
        @@options_hash["w"] ? @@total_word_count += word_count : nil
        byte_count = @@options_hash["c"] ? get_byte_count(file_path) : nil
        @@options_hash["c"] ? @@total_byte_count += byte_count : nil
        puts "#{line_count} #{word_count} #{byte_count} #{file_path}"
      end
      show_total?
    end
  end

 

  private  
  def show_total?
    puts "#{@@total_line_count == 0 ? nil : @@total_line_count} " +  
        "#{@@total_word_count == 0 ? nil : @@total_word_count} " +
        "#{@@total_byte_count == 0 ? nil : @@total_byte_count} total" if @@file_paths.size > 1
  end

  def no_options?
    @@options_hash.values.all? { |value| value == false } 
  end

  def get_byte_count(file)
    File.size(file) 
  end

  def get_line_count(file)
    line_count = 0
    File.foreach(file) do |line|
      line_count += 1
    end
    line_count
  end

  def get_word_count(file)
    File.read(file).split(/\s+/).size
  end

  def get_character_count(file)
    File.read(file).size
  end

  class << self 
    def parse(args)
      files_index = 0 
      args.each do |arg| 
        if arg =~ /^-/ 
          valid_option?(arg)
          files_index += 1
        else
          break
        end
      end
      args[files_index..-1].each do |file_path|
        if File.file?(file_path)
          @@file_paths << file_path
        else 
          puts "ccwc: #{file_path}: open: No such file or directory"
        end
      end
    end

    def valid_option?(option)
      option[1..-1].each_char do |char| 
        if @@options_hash[char] == false
          @@options_hash[char] = true
        elsif @@options_hash[char] == nil
          puts "ccwc: illegal option -- #{char}"
          puts "usage: ccwc [-clmw] [file ...]"
          exit
        end 
      end
    end
  end
end

ccwc = CCWC.new(ARGV)
ccwc.compute()