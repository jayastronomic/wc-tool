# frozen_string_literal: true

require_relative "../src/ccwc"

RSpec.describe CCWC do
  let(:file) { "testfile.txt" }

  before do
    File.write(file, "This is a test.\nWith two lines.")
  end

  after do
    File.delete(file)
  end

  context "when no options are passed" do
    it "counts lines, words, and bytes correctly for a single file" do
      expect { described_class.new([file]).compute }.to output("2 7 31 #{file}\n").to_stdout
    end
  end

  context "when -l option is passed" do
    it "only counts lines correctly for a single file" do
      expect { described_class.new(["-l", file]).compute }.to output("2 #{file}\n").to_stdout
    end
  end

  context "when -w option is passed" do
    it "only counts words correctly for a single file" do
      expect { described_class.new(["-w", file]).compute }.to output("7 #{file}\n").to_stdout
    end
  end

  context "when -c option is passed" do
    it "only counts bytes correctly for a single file" do
      expect { described_class.new(["-c", file]).compute }.to output("31 #{file}\n").to_stdout
    end
  end

  context "when -m option is passed" do
    it "only counts characters correctly for a single file" do
      expect { described_class.new(["-m", file]).compute }.to output("31 #{file}\n").to_stdout
    end
  end

  context "when multple files are passed with no options" do
    it "counts the total for lines, words, and bytes" do
      ccwc = described_class.new([file, file])
      expected = "2 7 31 testfile.txt\n2 7 31 testfile.txt\n4 14 62 total\n"
      expect { ccwc.compute }.to output(expected).to_stdout
    end
  end
end
