require 'pathname'
require 'minitest/autorun'

class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    gsub(%r{[-_/]}, "_").
    downcase
  end
end

def info(ft, pwd, current_filename, query)
end

def pattern_to_regex(pattern)
  Regexp.new(
    pattern.split(/([*?]+)/).map do |str|
      case str[0]
      when '*' then '.*'
      when '?' then '.'
      else Regexp.escape(str)
      end
    end.join
  )
end

def info_js(pwd, current_filename, query)
  absolute_current_filename =
    if current_filename.start_with?("/")
      current_filename
    else
      File.join(pwd, current_filename)
    end

  search_dir =
    case absolute_current_filename
    when %r{ app/assets/javascripts/ }x
        absolute_current_filename.gsub(%r{ (app/assets/javascripts)/.* }x, '\1')
    else pwd
    end

  underscored = query.underscore
  underscored.gsub!(%r{\A[-_/.]+}, '')
  underscored.gsub!(%r{[-_/.]+\z}, '')

  guessed_pattern =
    case underscored
    when /(.*)_paginator/ then "paginators/#{$~[1].gsub('_', '?')}"
    when /(.*)_controller/ then "controllers/#{$~[1].gsub('_', '?')}"
    when /(.*)_route/ then "routes/#{$~[1].gsub('_', '?')}"
    when /(.*)_service/ then "services/#{$~[1].gsub('_', '?')}"
    else underscored.gsub('_', '?')
    end

  guessed_regex = guessed_pattern && pattern_to_regex(guessed_pattern)
  guessed_filenames = find(search_dir: search_dir, regex: guessed_regex).map do |filename|
    Pathname.new(filename).relative_path_from(Pathname.new(pwd)).to_s
  end

  {
    absolute_current_filename: absolute_current_filename,
    search_dir: search_dir,
    underscored: underscored,
    guessed_pattern: guessed_pattern,
    guessed_regex: guessed_regex,
    guessed_filenames: guessed_filenames,
  }
end

def find(search_dir:, pattern: nil, regex: nil)
  unless pattern || regex
    fail ArgumentError, "must specify pattern or regex"
  end

  all_files = Dir.glob(File.join(search_dir, "**", "*"))
  regex ||= pattern_to_regex(pattern)
  all_files.select{ |file| file =~ regex }
end

describe "Info" do
  it "..." do
    pwd = File.join(__dir__, "better-vim-find-test-tree")
    current_filename = "app/assets/javascripts/ember-app/controllers/foo.jsx"
    identifier = "EnduserWidgetsController"

    info = info_js(pwd, current_filename, identifier)

    info[:search_dir].must_equal File.join(pwd, "app", "assets", "javascripts")
    info[:underscored].must_equal "enduser_widgets_controller"
    info[:guessed_pattern].must_equal "controllers/enduser?widgets"
    info[:guessed_filenames].must_equal ["app/assets/javascripts/ember-app/controllers/enduser/widgets.jsx"]
  end

  it "..." do
    pwd = File.join(__dir__, "better-vim-find-test-tree")
    current_filename = "app/assets/javascripts/ember-app/controllers/foo.jsx"
    identifier = "EnduserFooBarsController"

    info = info_js(pwd, current_filename, identifier)

    info[:search_dir].must_equal File.join(pwd, "app", "assets", "javascripts")
    info[:underscored].must_equal "enduser_foo_bars_controller"
    info[:guessed_pattern].must_equal "controllers/enduser?foo?bars"
    info[:guessed_filenames].must_equal ["app/assets/javascripts/ember-app/controllers/enduser/foo_bars.jsx"]
  end

  it "..." do
    pwd = File.join(__dir__, "better-vim-find-test-tree")
    current_filename = "app/assets/javascripts/ember-app/controllers/foo.jsx"
    identifier = "EnduserMakingStuffUpController"

    info = info_js(pwd, current_filename, identifier)

    info[:search_dir].must_equal File.join(pwd, "app", "assets", "javascripts")
    info[:guessed_filenames].must_equal ["app/assets/javascripts/ember-app/controllers/enduser/making-stuff-up.jsx"]
  end

  it "..." do
    pwd = File.join(__dir__, "better-vim-find-test-tree")
    current_filename = "app/assets/javascripts/ember-app/controllers/foo.jsx"
    identifier = "__enduserWidgetsController"

    info = info_js(pwd, current_filename, identifier)

    info[:search_dir].must_equal File.join(pwd, "app", "assets", "javascripts")
    info[:underscored].must_equal "enduser_widgets_controller"
    info[:guessed_pattern].must_equal "controllers/enduser?widgets"
    info[:guessed_filenames].must_equal ["app/assets/javascripts/ember-app/controllers/enduser/widgets.jsx"]
  end

  it "..." do
    pwd = File.join(__dir__, "better-vim-find-test-tree")
    current_filename = "app/assets/javascripts/ember-app/controllers/foo.jsx"
    identifier = "EnduserWidgets"

    info = info_js(pwd, current_filename, identifier)

    info[:search_dir].must_equal File.join(pwd, "app", "assets", "javascripts")
    info[:underscored].must_equal "enduser_widgets"
    info[:guessed_pattern].must_equal "enduser?widgets"
    info[:guessed_filenames].must_equal ["app/assets/javascripts/ember-app/controllers/enduser/widgets.jsx"]
  end

  it "..." do
    pwd = File.join(__dir__, "better-vim-find-test-tree")
    current_filename = "app/assets/javascripts/ember-app/controllers/foo.jsx"
    identifier = "enduserWidgets"

    info = info_js(pwd, current_filename, identifier)

    info[:search_dir].must_equal File.join(pwd, "app", "assets", "javascripts")
    info[:underscored].must_equal "enduser_widgets"
    info[:guessed_pattern].must_equal "enduser?widgets"
    info[:guessed_filenames].must_equal ["app/assets/javascripts/ember-app/controllers/enduser/widgets.jsx"]
  end

  it "..." do
    pwd = File.join(__dir__, "better-vim-find-test-tree")
    current_filename = "app/assets/javascripts/ember-app/controllers/foo.jsx"
    identifier = "enduser-widgets"

    info = info_js(pwd, current_filename, identifier)

    info[:search_dir].must_equal File.join(pwd, "app", "assets", "javascripts")
    info[:underscored].must_equal "enduser_widgets"
    info[:guessed_pattern].must_equal "enduser?widgets"
    info[:guessed_filenames].must_equal ["app/assets/javascripts/ember-app/controllers/enduser/widgets.jsx"]
  end

  it "..." do
    pwd = File.join(__dir__, "better-vim-find-test-tree")
    current_filename = "app/assets/javascripts/ember-app/controllers/foo.jsx"
    identifier = "enduser_widgets"

    info = info_js(pwd, current_filename, identifier)

    info[:search_dir].must_equal File.join(pwd, "app", "assets", "javascripts")
    info[:underscored].must_equal "enduser_widgets"
    info[:guessed_pattern].must_equal "enduser?widgets"
    info[:guessed_filenames].must_equal ["app/assets/javascripts/ember-app/controllers/enduser/widgets.jsx"]
  end
end
