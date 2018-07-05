RSpec.describe Scrapbox2markdown::Converters::List do
  describe '#convert!' do
    context 'When passing a single line starting with a white space' do
      subject(:line) { [' List'] }
      before do
        converter = Scrapbox2markdown::Converters::List.new(line)
        converter.convert!
      end

      it { is_expected.to match(['- List']) }
    end

    context 'When passing a single line starting with a tab' do
      subject(:line) { ["\tList"] }
      before do
        converter = Scrapbox2markdown::Converters::List.new(line)
        converter.convert!
      end

      it { is_expected.to match(['- List']) }
    end

    context 'When passing a single line starting with a white space and a tab' do
      # 空白とタブが混在し２文字分のインデント
      subject(:line) { [" \tList"] }
      before do
        converter = Scrapbox2markdown::Converters::List.new(line)
        converter.convert!
      end

      it { is_expected.to match(['  - List']) }
    end

    context 'When passing a single line starting with two white spaces ' do
      subject(:line) { ['  List'] }
      before do
        converter = Scrapbox2markdown::Converters::List.new(line)
        converter.convert!
      end

      # マークダウンの場合は先頭に２つ空白を入れる
      it { is_expected.to match(['  - List']) }
    end

    context 'When passing a multiple lines starting with a white space' do
      subject(:lines) { [' First', ' Second'] }
      before do
        converter = Scrapbox2markdown::Converters::List.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['- First', '- Second']) }
    end

    context 'When nested lists' do
      subject(:lines) { [' First', '  Second', '   Third'] }
      before do
        converter = Scrapbox2markdown::Converters::List.new(lines)
        converter.convert!
      end

      # マークダウンの場合は２段目が空白２つ、３段目が空白４つ先頭に入れる
      it { is_expected.to match(['- First', '  - Second', '    - Third']) }
    end
  end
end
