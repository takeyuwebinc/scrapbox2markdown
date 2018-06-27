RSpec.describe Scrapbox2docbase::Converters::Heading do
  describe '#convert!' do
    context 'When passing a single line' do
      subject(:line) { ['[***** Heading]'] }
      before do
        converter = Scrapbox2docbase::Converters::Heading.new(line)
        converter.convert!
      end

      it { is_expected.to match(['# Heading']) }
    end

    context 'When passing a multiple line' do
      subject(:lines) { ['[***** Heading]', 'and', '[****** PLAIN_TEXT]'] }
      before do
        converter = Scrapbox2docbase::Converters::Heading.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['# Heading', 'and', 'PLAIN_TEXT']) }
    end

    context 'When a line includes an inline code' do
      subject(:lines) { ['[***** `Heading`]'] }
      before do
        converter = Scrapbox2docbase::Converters::Heading.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['# `Heading`']) }
    end

    context 'When a heading is in inline code' do
      subject(:lines) { ['`[***** Heading]`'] }
      before do
        converter = Scrapbox2docbase::Converters::Heading.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['`[***** Heading]`']) }
    end

    context 'When a heading with extra characters is in inline code' do
      subject(:lines) { ['`Some[***** Heading]Thing`'] }
      before do
        converter = Scrapbox2docbase::Converters::Heading.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['`Some[***** Heading]Thing`']) }
    end
  end
end