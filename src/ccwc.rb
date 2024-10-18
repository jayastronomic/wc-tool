# CCWC (Crickett Coding Word Count) - A simplified version of the Linux `wc` command-line utility.
#
# This class is designed to mimic the behavior of the Linux `wc` command, computing the number
# of lines, words, characters, and bytes in files. The class processes multiple file paths and handles specific
# options passed as arguments.
class CCWC
  # Initializes the CCWC object and parses the command-line arguments.
  #
  # @param [Array<String>] args The command-line arguments (file paths and options).
  #   The options include:
  #     - `-l`: line count
  #     - `-w`: word count
  #     - `-c`: byte count
  #     - `-m`: character count
  #   If no options are passed, it defaults to counting lines, words, and bytes.
  def initialize(args)
    @total_line_count = 0
    @total_word_count = 0
    @total_byte_count = 0
    @total_character_count = 0
    @file_paths = []
    @options_hash = {
      "l" => false, # Line count option
      "w" => false, # Word count option
      "c" => false, # Byte count option
      "m" => false, # Character count option
    }
    parse(args)
  end

  # Computes the line, word, byte, and character counts for each file based on the options passed.
  #
  # If no options are provided, it defaults to showing line, word, and byte counts. It also
  # displays the total counts if multiple files are processed.
  def compute
    if no_options?
      @file_paths.each do |file_path|
        line_count = get_line_count(file_path)
        @total_line_count += line_count
        word_count = get_word_count(file_path)
        @total_word_count += word_count
        byte_count = get_byte_count(file_path)
        @total_byte_count += byte_count
        puts "#{line_count} #{word_count} #{byte_count} #{file_path}"
      end
      show_total?
    else
      @file_paths.each do |file_path|
        line_count = @options_hash["l"] ? get_line_count(file_path) : nil
        @options_hash["l"] ? @total_line_count += line_count : nil
        word_count = @options_hash["w"] ? get_word_count(file_path) : nil
        @options_hash["w"] ? @total_word_count += word_count : nil
        byte_count = @options_hash["c"] ? get_byte_count(file_path) : nil
        @options_hash["c"] ? @total_byte_count += byte_count : nil
        character_count = @options_hash["m"] ? get_character_count(file_path) : nil
        @options_hash["m"] ? @total_character_count += character_count : nil
        format_output(line_count, word_count, byte_count, character_count, file_path)
      end
      show_total?
    end
  end

  private

  # Formats the output based on the options passed.
  #
  # @param [Integer, nil] line_count The line count for the file (if requested).
  # @param [Integer, nil] word_count The word count for the file (if requested).
  # @param [Integer, nil] byte_count The byte count for the file (if requested).
  # @param [Integer, nil] character_count The character count for the file (if requested).
  # @param [String] file_path The file path being processed.
  def format_output(*args)
    line_count, word_count, byte_count, character_count, file_path = args
    if byte_count && character_count
      puts [line_count, word_count, byte_count, file_path].compact.join(" ")
    elsif !byte_count && character_count
      puts [line_count, word_count, character_count, file_path].compact.join(" ")
    else
      puts [line_count, word_count, byte_count, file_path].compact.join(" ")
    end
  end

  # Displays the total counts (line, word, and byte) if more than one file is processed.
  #
  # This method will print the cumulative counts across multiple files for the selected options.
  def show_total?
    puts "#{@total_line_count == 0 ? nil : @total_line_count} " +
           "#{@total_word_count == 0 ? nil : @total_word_count} " +
           "#{@total_byte_count == 0 ? nil : @total_byte_count} total" if @file_paths.size > 1
  end

  # Checks if no options were provided by the user.
  #
  # If no options are provided, it defaults to counting lines, words, and bytes.
  #
  # @return [Boolean] Returns true if no options were passed, otherwise false.
  def no_options?
    @options_hash.values.all? { |value| value == false }
  end

  # Returns the byte count of the specified file.
  #
  # @param [String] file The file path.
  # @return [Integer] The size of the file in bytes.
  def get_byte_count(file)
    File.size(file)
  end

  # Returns the line count of the specified file.
  #
  # @param [String] file The file path.
  # @return [Integer] The number of lines in the file.
  def get_line_count(file)
    line_count = 0
    File.foreach(file) do |line|
      line_count += 1
    end
    line_count
  end

  # Returns the word count of the specified file.
  #
  # @param [String] file The file path.
  # @return [Integer] The number of words in the file.
  def get_word_count(file)
    File.read(file).split(/\s+/).size
  end

  # Returns the character count of the specified file.
  #
  # @param [String] file The file path.
  # @return [Integer] The number of characters in the file.
  def get_character_count(file)
    File.read(file).size
  end

  # Parses the command-line arguments to extract options and file paths.
  #
  # @param [Array<String>] args The command-line arguments (file paths and options).
  #   The arguments can include file paths and options for line count (-l), word count (-w), byte count (-c), and character count (-m).
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
        @file_paths << file_path
      else
        puts "ccwc: #{file_path}: open: No such file or directory"
      end
    end
  end

  # Validates the option passed as an argument.
  #
  # @param [String] option The option (e.g., "-l" for line count).
  # @raise [SystemExit] If an illegal option is passed.
  def valid_option?(option)
    option[1..-1].each_char do |char|
      if @options_hash[char] == false
        @options_hash[char] = true
      elsif @options_hash[char].nil?
        puts "ccwc: illegal option -- #{char}"
        puts "usage: ccwc [-clmw] [file ...]"
        exit
      end
    end
  end
end

ccwc = CCWC.new(ARGV)
ccwc.compute
