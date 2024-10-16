class CCWC 
  OPTIONS = ["-c", "-l", "-w", "-m", "-L"]
  @@option = nil
  @@file_name= nil

  def initialize(args)
    CCWC.parse_args(args)
    run
  end

  def run 
    if @@option == OPTIONS[0]
      puts "#{count_bytes} #{@@file_name}"
    end
  end


  def count_lines
    line_count = 0 
    File.foreach(@@file_name) { line_count += 1 }
    line_count
  end

  def count_bytes
    File.size(@@file_name)
  end

  def count_words
    content = File.read(@@file_name)
    content.split(/\s+/).size
  end

  private 
  class << self 
    def parse_args(args)
      if OPTIONS.include?(args[0])
        @@option = args[0]
        @@file_name = args[1]
      else 
        @@file_name = args[0]
      end
    end
  end
end

CCWC.new(ARGV)