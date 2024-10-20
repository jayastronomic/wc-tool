#!/usr/bin/env ruby
# frozen_string_literal: true

# CCWC (Coding Challenge Word Count) - A simplified version of the Linux `wc` command-line utility.
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
    @options = %w[l w c m].each_with_object({}) do |option, options|
      options[option] = false
    end
    parse(args)
  end

  # Computes the line, word, byte, and character counts for each file based on the options passed.
  #
  # If no options are provided, it defaults to showing line, word, and byte counts. It also
  # displays the total counts if multiple files are processed.
  def compute
    no_options? ? process_files_without_options : process_files_with_options
    show_total?
  end

  private

  def process_files_without_options
    @file_paths.each do |file_path|
      line_count = get_line_count(file_path)
      word_count = get_word_count(file_path)
      byte_count = get_byte_count(file_path)
      puts "#{line_count} #{word_count} #{byte_count} #{file_path}"
    end
  end

  def process_files_with_options
    @file_paths.each do |file_path|
      line_count = @options["l"] ? get_line_count(file_path) : nil
      word_count = @options["w"] ? get_word_count(file_path) : nil
      byte_count = @options["c"] ? get_byte_count(file_path) : nil
      character_count = @options["m"] ? get_character_count(file_path) : nil

      format_output(line_count, word_count, byte_count, character_count, file_path)
    end
  end

  # Formats the output based on the options passed.
  #
  # @param [Integer, nil] line_count The line count for the file (if requested).
  # @param [Integer, nil] word_count The word count for the file (if requested).
  # @param [Integer, nil] byte_count The byte count for the file (if requested).
  # @param [Integer, nil] character_count The character count for the file (if requested).
  # @param [String] file_path The file path being processed.
  def format_output(*args)
    puts args.compact.uniq.join(" ")
  end

  # Displays the total counts (line, word, and byte) if more than one file is processed.
  #
  # This method will print the cumulative counts across multiple files for the selected options.
  def show_total?
    return unless @file_paths.size > 1

    puts "#{@total_line_count.zero? ? nil : @total_line_count} " \
         "#{@total_word_count.zero? ? nil : @total_word_count} " \
         "#{@total_byte_count.zero? ? nil : @total_byte_count} total"
  end

  # Checks if no options were provided by the user.
  #
  # If no options are provided, it defaults to counting lines, words, and bytes.
  #
  # @return [Boolean] Returns true if no options were passed, otherwise false.
  def no_options?
    @options.values.all? { |value| value == false }
  end

  # Returns the byte count of the specified file.
  #
  # @param [String] file The file path.
  # @return [Integer] The size of the file in bytes.
  def get_byte_count(file)
    @total_byte_count += byte_count = File.size(file)
    byte_count
  end

  # Returns the line count of the specified file.
  #
  # @param [String] file The file path.
  # @return [Integer] The number of lines in the file.
  def get_line_count(file)
    line_count = 0
    File.foreach(file) { line_count += 1 }
    @total_line_count += line_count
    line_count
  end

  # Returns the word count of the specified file.
  #
  # @param [String] file The file path.
  # @return [Integer] The number of words in the file.
  def get_word_count(file)
    @total_word_count += word_count = File.read(file).split(/\s+/).size
    word_count
  end

  # Returns the character count of the specified file.
  #
  # @param [String] file The file path.
  # @return [Integer] The number of characters in the file.
  def get_character_count(file)
    @total_character_count += char_count = File.read(file).size
    char_count
  end

  # Parses the command-line arguments to extract options and file paths.
  #
  # @param [Array<String>] args The command-line arguments (file paths and options).
  #   The arguments can include file paths and options for line count (-l), word count (-w), byte count (-c), and character count (-m).
  def parse(args)
    files_index = 0
    args.each do |arg|
      break unless arg =~ /^-/

      valid_option?(arg)
      files_index += 1
    end
    store_files(args[files_index..])
  end

  def store_files(file_paths)
    file_paths.each do |file_path|
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
    option[1..].each_char do |char|
      if @options[char] == false
        @options[char] = true
      elsif @options[char].nil?
        puts "ccwc: illegal option -- #{char}"
        puts "usage: ccwc [-clmw] [file ...]"
        exit
      end
    end
  end
end

ccwc = CCWC.new(ARGV)
ccwc.compute
