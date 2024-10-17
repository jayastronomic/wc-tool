# CCWC - Crickett Coding Word Count

CCWC (Crickett Coding Word Count) is a simplified version of the Linux `wc` command-line utility. It computes the number of lines, words, characters, and bytes in files, mimicking the behavior of the `wc` command.

## Features

- Count the number of lines, words, characters, and bytes in files.
- Process multiple files at once.
- Support for specific options to calculate only what you need (lines, words, bytes, characters).
- Defaults to calculating lines, words, and bytes if no options are provided.
- Handles non-existent files gracefully by printing error messages.

## Usage

```bash
ruby ccwc.rb [OPTION]... [FILE]...
```

## Options

- -l : Output the number of lines in the file(s).
- -w : Output the number of words in the file(s).
- -c : Output the number of bytes in the file(s).
- -m : Output the number of characters in the file(s).
  If no options are specified, CCWC will output the line count, word count, and byte count by default.
