require "tempfile"

def temp_file_with_contents(filename)
  Tempfile.new(split_filename_separator_extension(filename)).tap do |file|
    file.write yield
    file.flush
  end
end

def split_filename_separator_extension(filename)
  separator_index = filename.index(".")
  [
    filename.slice(0, separator_index),
    filename.slice(separator_index, filename.length)
  ]
end
