#!/usr/bin/env bash
# vim: set ft=ruby:

# This file executes as a bash script, which turns around and executes Ruby via
# the line below. The -x argument to Ruby makes it discard everything before
# the second "!ruby" shebang. This allows us to work on Linux, where the
# shebang can only have one argument so we can't directly say
# "#!/usr/bin/env ruby --disable-gems". Thanks for that, Linux.
#
# If this seems confusing, don't worry. You can treat it as a normal Ruby file
# starting with the "!ruby" shebang below.

exec /usr/bin/env ruby --disable-gems -x "$0" $*
#!ruby

class Irregular < Struct.new(:singular, :plural)
  def stub
    @stub ||= singular.chars.zip(plural.chars).take_while{ |a,b| a == b }.map(&:first).join
  end

  def remove_suffix(word)
    if word.downcase.end_with?(singular)
      word.gsub(/#{Regexp.escape(singular)}$/i, stub)
    elsif word.downcase.end_with?(plural)
      word.gsub(/#{Regexp.escape(plural)}$/i, stub)
    else
      word
    end
  end

  def match?(word)
    word.downcase.end_with?(singular) || word.downcase.end_with?(plural)
  end
end

IRREGULARS = [
  ["elf", "elves"],
  ["calf", "calves"],
  ["knife", "knives"],
  ["loaf", "loaves"],
  ["shelf", "shelves"],
  ["wolf", "wolves"],
  ["loaf", "loaves"],
  ["man", "men"],
  ["person", "people"],
  ["mouse", "mice"],
  ["child", "children"],
  ["foot", "feet"],
  ["goose", "geese"],
  ["tooth", "teeth"],
  ["louse", "lice"],
  ["cactus", "cacti"],
  ["appendix", "appendices"],
  ["ox", "oxen"],
].map do |singular, plural|
  Irregular.new(singular, plural)
end

def remove_suffix(word)
  if(irregular = IRREGULARS.find{ |irregular| irregular.match?(word) })
    return irregular.remove_suffix(word)
  end

  case word
  when /^(.*)ium$/i then "#{$1}i"
  when /^(.*)ia$/i then "#{$1}i"
  when /^(.*)es$/i then $1
  when /^(.*)s$/i then $1
  else word
  end
end

puts remove_suffix(ARGV.first || $stdin.read)
