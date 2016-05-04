# frozen_string_literal: true
HTML_FOMATTER = lambda do |context|
  puts('<html>')
  puts("  <title>#{context.title}</title>")
  puts('  <body>')
  context.text.each do |line|
    puts("    <p>#{line}</p>")
  end
  puts('  </body>')
  puts('</html>')
end

class Report
  attr_reader :title, :text

  attr_accessor :formatter

  def initialize(title:, text:)
    @title = title
    @text = text
  end

  def output_report(&_block)
    if block_given?
      yield(self)
    else
      formatter.call(self)
    end
  end
end

## Usage

report = Report.new(title: 'Hello', text: %w(Franky Max))
report.formatter = HTML_FOMATTER

report.output_report
puts

report.output_report do |context|
  puts("***** #{context.title} *****")
  context.text.each do |line|
    puts(line)
  end
end
