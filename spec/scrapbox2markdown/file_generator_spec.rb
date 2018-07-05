require 'pathname'

RSpec.describe Scrapbox2markdown::FileGenerator do
  output_path = 'spec/exports/generated'
  it "generates .md from .json to #{output_path}" do
    # カレントディレクトリの.jsonからテスト用ディレクトリに.mdを生成する
    file_generator = Scrapbox2markdown::FileGenerator.new('test.json', "#{output_path}")
    file_generator.generate
    expect(Dir.exist?("./#{output_path}")).to be true
    expect(Dir.empty?("./#{output_path}")).to be false
  end
end
