require 'pathname'

RSpec.describe Scrapbox2markdown::FileGenerator do
  output_path = 'tmp'
  it "should generate .md from .json to #{output_path}" do
    # カレントディレクトリの.jsonからテスト用ディレクトリに.mdを生成する
    file_generator = Scrapbox2markdown::FileGenerator.new('test.json', "#{output_path}")
    file_generator.generate
    expect(Dir.exist?("./#{output_path}")).to be true
    expect(Dir.empty?("./#{output_path}")).to be false
  end

  describe 'Embedded YAML metadata' do
    shared_examples 'YAML metadata' do |path, to_be_loaded|
      it 'should be able to load YAML metadata ' do
        open(path) do |file|
          expect(YAML.load(file.read)).to eq to_be_loaded
        end
      end
    end

    include_examples 'YAML metadata',
                     './tmp/はじめに.md',
                     { "title"      => "はじめに",
                       "created_at" => Time.new(2018, 03, 26, 22, 52, 30, '+09:00'),
                       "updated_at" => Time.new(2018, 04, 21, 11, 51,  9, '+09:00') }

    include_examples 'YAML metadata',
                     './tmp/健康診断.md',
                     { "title"      =>"健康診断",
                       "created_at" => Time.new(2018, 03, 26, 22, 54, 19, '+09:00'),
                       "updated_at" => Time.new(2018, 03, 26, 22, 55, 54, '+09:00') }
  end
end
