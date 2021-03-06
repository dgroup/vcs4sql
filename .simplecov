if Gem.win_platform? then
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter
  ]
  SimpleCov.start do
    add_filter "/test/"
    add_filter "/features/"
    minimum_coverage 90
  end
else
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
    [SimpleCov::Formatter::HTMLFormatter]
  )
  SimpleCov.start do
    add_filter "/test/"
    add_filter "/features/"
    minimum_coverage 90
  end
end
