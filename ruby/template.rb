# frozen_string_literal: true
# Abstract class
# Used as a template for actual reports
class Report
  #
  # @title: String
  # @text: String[]
  #
  def initialize(title:, text:)
    @title = title
    @text = text
  end

  def output_report
    output_start
    output_head
    @text.each do |word|
      output_line(word)
    end
    output_end
  end

  private

  def output_start
  end

  def output_head
  end

  def output_line(_word)
    raise NotImplementedError, "You have to implement #{self.class}##{__method__}"
  end

  def output_end
  end
end

class HTMLReport < Report
  def output_start
    puts '<html>'
  end

  def output_head
    puts "  <title>#{@title}</title>"
  end

  def output_line(word)
    puts "  <p>#{word}</p>"
  end

  def output_end
    puts '</html>'
  end
end

class MarkdownReport < Report
  def output_head
    puts "***** #{@title} *****"
  end

  def output_line(word)
    puts word
  end
end

class InvalidReport < Report
end

report = HTMLReport.new(title: 'Hello', text: %w(Franky Max))
report.output_report
puts
report = MarkdownReport.new(title: 'Hello', text: %w(Franky Max))
report.output_report
puts
report = InvalidReport.new(title: 'Hello', text: %w(Franky Max))
report.output_report
