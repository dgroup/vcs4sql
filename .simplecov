if Gem.win_platform? then
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter
  ]
  SimpleCov.start do
    add_filter "/test/"
    add_filter "/features/"
    add_filter "Rakefile"
    add_filter "Gemfile"
  end
else
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
    [SimpleCov::Formatter::HTMLFormatter]
  )
  SimpleCov.start do
    add_filter "/test/"
    add_filter "/features/"
    add_filter "Rakefile"
    add_filter "Gemfile"
    minimum_coverage 80
  end
end
