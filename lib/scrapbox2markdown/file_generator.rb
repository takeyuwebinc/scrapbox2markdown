require 'fileutils'
require 'json'

module Scrapbox2markdown
  class FileGenerator
    def initialize(input, output)
      @input = input
      @output = output
    end

    def generate
      pages = import("#{@input}")
      pages.each do |page|
        lines = page['lines'].map(&:chomp)
        Scrapbox2markdown::Converter.new(lines).convert!
        export(lines: lines, filename: page['title'])
      end
    end

    private

    def output_dir
      "#{Dir.pwd}/#{@output}"
    end

    def import(input)
      file = File.read("#{Dir.pwd}/#{input}")
      json = JSON.parse(file)
      json['pages']
    end

    def export(lines:, filename:)
      FileUtils.mkdir_p("#{output_dir}")
      File.open("#{output_dir}/#{filename}.md", "w") do |io|
        lines.each { |line| io.puts(line) }
      end
    end
  end
end
