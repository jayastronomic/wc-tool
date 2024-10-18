require_relative "../src/ccwc"

RSpec.describe CCWC do
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
end
