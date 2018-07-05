RSpec.describe Scrapbox2markdown::Converters::Heading do
  describe '#convert!' do
    context 'When passing a single line' do
      subject(:line) { ['[***** Heading]'] }
      before do
        converter = Scrapbox2markdown::Converters::Heading.new(line)
        converter.convert!
      end

      it { is_expected.to match(['# Heading']) }
    end

    context 'When passing a multiple line' do
      subject(:lines) { ['[***** Heading]', 'and', '[****** PLAIN_TEXT]'] }
      before do
        converter = Scrapbox2markdown::Converters::Heading.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['# Heading', 'and', 'PLAIN_TEXT']) }
    end

    context 'When a line includes an inline code' do
      subject(:lines) { ['[***** `Heading`]'] }
      before do
        converter = Scrapbox2markdown::Converters::Heading.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['# `Heading`']) }
    end

    context 'When a heading is in inline code' do
      subject(:lines) { ['`[***** Heading]`'] }
      before do
        converter = Scrapbox2markdown::Converters::Heading.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['`[***** Heading]`']) }
    end

    context 'When a heading with extra characters is in inline code' do
      subject(:lines) { ['`Some[***** Heading]Thing`'] }
      before do
        converter = Scrapbox2markdown::Converters::Heading.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['`Some[***** Heading]Thing`']) }
    end

    # １行の中に見出しとインラインコードが混在している場合
    # このパターンはほぼないのではないかと思われるが・・・
    context 'When a heading with extra characters is in inline code' do
      subject(:lines) { ['[***** Heading] and `[***** Inline]`'] }
      before do
        converter = Scrapbox2markdown::Converters::Heading.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['# Heading and `[***** Inline]`']) }
    end
  end
end
