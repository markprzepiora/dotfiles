if File.exists?('/proc/version') && File.read('/proc/version').include?('WSL')
  class String
    def pbcopy
      IO.popen(%w(xclip -selection clipboard -in), 'w') { |f| f << self }
      self
    end
  end

  def pbpaste
    `~/Dropbox/bin/windows/paste.exe`
  end
end

# copy history
def ch(*args)
  lines = ["", *Pry.history.to_a[(-Pry.history.session_line_count)..-1]]
  line_numbers = args.map do |arg|
    case arg
    when Integer then [arg]
    when Range then arg.to_a
    end
  end.flatten(1)

  lines.values_at(*line_numbers).compact.join("\n").pbcopy
end

def dh(*args)
  if args.empty?
    Pry.history.clear
  end

  line_count = Pry.history.session_line_count

  indexes_to_delete = args.map do |arg|
    case arg
    when Integer then [arg]
    when Range then arg.to_a
    else fail "#{arg.inspect} is not a line number or range"
    end
  end.flatten.map do |line|
    line - 1
  end

  p indexes_to_delete

  old_history = Pry.history.to_a[(-line_count)..-1]
  new_history = old_history.reject.with_index do |line, index|
    indexes_to_delete.include?(index)
  end

  p old_history
  p new_history
end

if Pry.config.history.respond_to?(:histignore)
  Pry.config.history.histignore ||= []
  Pry.config.history.histignore << /^hist\b/
  Pry.config.history.histignore << /^history\b/
end
