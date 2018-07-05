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
        header = yaml_header(page)
        lines = page['lines'].map(&:chomp)
        Scrapbox2markdown::Converter.new(lines).convert!
        export(lines: lines.prepend(header), filename: page['title'])
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

    # Markdownファイルの先頭に埋め込むため、YAML形式で出力する
    # ---
    # title: "はじめに"
    # created_at: 2018-03-26 22:52:30 +0900
    # updated_at: 2018-04-21 11:51:09 +0900
    # ---
    #
    def yaml_header(page)
      <<~YAML
      ---
      title: "#{page['title']}"
      created_at: #{Time.at(page['created'])}
      updated_at: #{Time.at(page['updated'])}
      ---

      YAML
    end
  end
end
