require 'scrapbox2docbase'
require 'thor'
require 'scrapbox2docbase/file_generator'

module Scrapbox2docbase
  class CLI < Thor
    default_command :generate
    options input: :string, output: :string
    desc 'generate', 'generate .md from .json to path/to/output'
    def generate
      file_generator = Scrapbox2docbase::FileGenerator.new(options[:input], options[:output])
      file_generator.generate
    end
  end
end
