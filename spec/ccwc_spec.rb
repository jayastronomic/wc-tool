# frozen_string_literal: true

require_relative "../src/ccwc"

RSpec.describe CCWC do # rubocop:disable Metrics/BlockLength
  before(:each) do
    @file = "testfile.txt"
    File.write(@file, "This is a test.\nWith two lines.")
  end

  after(:each) do
    File.delete(@file) if File.exist?(@file)
  end

  context "when no options are passed" do
    it "counts lines, words, and bytes correctly for a single file" do
      ccwc = CCWC.new([@file])
      expect { ccwc.compute }.to output("2 7 31 #{@file}\n").to_stdout
    end
  end

  context "when -l option is passed" do
    it "only counts lines correctly for a single file" do
      ccwc = CCWC.new(["-l", @file])
      expect { ccwc.compute }.to output("2 #{@file}\n").to_stdout
    end
  end

  context "when -w option is passed" do
    it "only counts words correctly for a single file" do
      ccwc = CCWC.new(["-w", @file])
      expect { ccwc.compute }.to output("7 #{@file}\n").to_stdout
    end
  end

  context "when -c option is passed" do
    it "only counts bytes correctly for a single file" do
      ccwc = CCWC.new(["-c", @file])
      expect { ccwc.compute }.to output("31 #{@file}\n").to_stdout
    end
  end

  context "when -m option is passed" do
    it "only counts characters correctly for a single file" do
      ccwc = CCWC.new(["-m", @file])
      expect { ccwc.compute }.to output("31 #{@file}\n").to_stdout
    end
  end

  context "when multple files are passed with no options" do
    it "counts the total for lines, words, and bytes" do
      ccwc = CCWC.new([@file, @file, @file])
      expected = <<~OUTPUT
        2 7 31 testfile.txt
        2 7 31 testfile.txt
        2 7 31 testfile.txt
        6 21 93 total
      OUTPUT
      expect { ccwc.compute }.to output(expected).to_stdout
    end
  end
end
