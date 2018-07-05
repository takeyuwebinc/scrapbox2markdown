RSpec.describe Scrapbox2markdown::Converters::Italic do
  describe '#convert!' do
    context 'When passing a single line including a multiple italic' do
      subject(:line) { ['[/ First] and [/ Second]'] }
      before do
        converter = Scrapbox2markdown::Converters::Italic.new(line)
        converter.convert!
      end

      it { is_expected.to match(['*First* and *Second*']) }
    end

    context 'When passing a single line including a multiple italic heading' do
      subject(:line) { ['[/* First] and [/* Second]'] }
      before do
        converter = Scrapbox2markdown::Converters::Italic.new(line)
        converter.convert!
      end

      it { is_expected.to match(['##### *First* and ##### *Second*']) }
    end

    context 'When passing italic and italic with heading' do
      subject(:lines) { ['[/ Italic]', 'and', '[/* Italic Heading]'] }
      before do
        converter = Scrapbox2markdown::Converters::Italic.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['*Italic*', 'and', '##### *Italic Heading*']) }
    end

    context 'When a line includes an inline code' do
      subject(:lines) { ['[/ `Italic`]'] }
      before do
        converter = Scrapbox2markdown::Converters::Italic.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['*`Italic`*']) }
    end

    context 'When an italic is in inline code' do
      subject(:lines) { ['`[/ Italic]`'] }
      before do
        converter = Scrapbox2markdown::Converters::Italic.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['`[/ Italic]`']) }
    end

    context 'When an italic with extra characters is in inline code' do
      subject(:lines) { ['`Some[/ Italic]Thing`'] }
      before do
        converter = Scrapbox2markdown::Converters::Italic.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['`Some[/ Italic]Thing`']) }
    end

    # １行の中にインライン（変換不可）とイタリックが混在している場合
    context 'When an inline code and an italic in the same line' do
      subject(:lines) { ['`[/ Italic]` ⇒ [/ Italic]'] }
      before do
        converter = Scrapbox2markdown::Converters::Italic.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['`[/ Italic]` ⇒ *Italic*']) }
    end

    # １行の中にインライン（変換不可）とイタリック（見出し）が混在している場合
    context 'When and inline code and an italic heading in the same line' do
      subject(:lines) { ['`[/* Italic]` ⇒ [/* Italic]'] }
      before do
        converter = Scrapbox2markdown::Converters::Italic.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['`[/* Italic]` ⇒ ##### *Italic*']) }
    end
  end
end
