require 'scrapbox2markdown'
require 'thor'
require 'scrapbox2markdown/file_generator'

module Scrapbox2markdown
  class CLI < Thor
    default_command :generate
    options input: :string, output: :string
    desc 'generate', 'generate .md from .json to path/to/output'
    def generate
      file_generator = Scrapbox2markdown::FileGenerator.new(options[:input], options[:output])
      file_generator.generate
    end
  end
end
