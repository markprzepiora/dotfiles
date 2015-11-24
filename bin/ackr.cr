require "process"
require "readline"

# Example usage (command line):
#
#     $ ackr '\bfoo\b' bar .
#
# The above replaces all instances of the regexp /\bfoo\b/ (word boundary, foo,
# word boundary) with the string "bar", in all files found by ack in the
# current directory.
#
# Example usage: (interactive mode):
#
# You can specify fewer than all three inputs (even zero) on the command line,
# and instead they will be read interactively.
#
#     $ ackr '\bfoo\b' bar
#     search: \bfoo\b
#     replace: bar
#     where: <prompt>

def get_input(name, args, n)
  default = args.at(n) { nil }

  if default
    STDERR.puts "#{name}: #{default}"
    STDERR.flush
    default
  else
    Readline.readline("#{name}: ", true) || ""
  end
end

def run(cmd, args)
  io = MemoryIO.new
  Process.run(cmd, args: args, output: io)
  io.to_s
end

home = ENV["HOME"]
ackr_dir = home + "/.ackr"
history_file = ackr_dir + "/history"

# Make sure we have our ~/.ackr directory and the history file.
Dir.mkdir_p(ackr_dir)
File.write(history_file, "") if !File.exists?(history_file)

# Read the existing history, and load it into Readline.
history_lines = File.read(history_file).split("\n")
(history_lines + ARGV).each do |line|
  LibReadline.add_history(line)
end

# Get the inputs.
search  = get_input("search",  ARGV, 0)
replace = get_input("replace", ARGV, 1)
where   = get_input("where",   ARGV, 2)

# Shell out to ag to find matching files.
files = run("ag", [search, "-l"] + where.split(" ")).split("\n")

files.each do |filename|
  # Perform the substitution in-memory. (Hoping these files aren't huge.)
  replaced_contents = File.read(filename).gsub(Regex.new(search, Regex::Options::EXTENDED), replace)

  # Write out the substituted contents.
  File.write(filename, replaced_contents)

  puts filename
end

STDERR.puts "performed substitutions in #{files.size} files"
STDERR.flush

# Write out the updated history before quitting
File.open(history_file, "a") do |file|
  file.puts(search)
  file.puts(replace)
  file.puts(where)
end
