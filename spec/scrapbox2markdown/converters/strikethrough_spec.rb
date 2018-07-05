RSpec.describe Scrapbox2markdown::Converters::Strikethrough do
  describe '#convert!' do
    context 'When passing a single line' do
      subject(:line) { ['[- Strikethrough]'] }
      before do
        converter = Scrapbox2markdown::Converters::Strikethrough.new(line)
        converter.convert!
      end

      it { is_expected.to match(['~~Strikethrough~~']) }
    end

    context 'When passing a single line including a multiple strikethrough' do
      subject(:line) { ['[- First] and [- Second]'] }
      before do
        converter = Scrapbox2markdown::Converters::Strikethrough.new(line)
        converter.convert!
      end

      it { is_expected.to match(['~~First~~ and ~~Second~~']) }
    end

    # TODO: ハイフンが途中にあった場合でも適用される
    xcontext 'When passing a single line (with heading)' do
      subject(:line) { ['[*-** Strikethrough]'] }
      before do
        converter = Scrapbox2markdown::Converters::Strikethrough.new(line)
        converter.convert!
      end

      it { is_expected.to match(['### ~~Strikethrough~~']) }
    end

    # 見出し打ち消し
    context 'When passing a single line including a multiple strikethrough with heading' do
      subject(:lines) { ['[-* First] and [-* Second]'] }
      before do
        converter = Scrapbox2markdown::Converters::Strikethrough.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['##### ~~First~~ and ##### ~~Second~~']) }
    end

    context 'When passing strikethrough and strikethrough with heading' do
      subject(:lines) { ['[- Strikethrough]', 'and', '[-* Strikethrough Heading]'] }
      before do
        converter = Scrapbox2markdown::Converters::Strikethrough.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['~~Strikethrough~~', 'and', '##### ~~Strikethrough Heading~~']) }
    end

    # 斜体見出し打ち消し
    context 'When passing a single line including a multiple strikethrough with italic heading' do
      subject(:lines) { ['[-*/ First] and [-*/ Second]'] }
      before do
        converter = Scrapbox2markdown::Converters::Strikethrough.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['##### ~~*First*~~ and ##### ~~*Second*~~']) }
    end

    context 'When passing strikethrough and strikethrough with italic heading' do
      subject(:lines) { ['[- Strikethrough]', 'and', '[-*/ Strikethrough Italic Heading]'] }
      before do
        converter = Scrapbox2markdown::Converters::Strikethrough.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['~~Strikethrough~~', 'and', '##### ~~*Strikethrough Italic Heading*~~']) }
    end

    context 'When a line including an inline code' do
      subject(:lines) { ['[- `Strikethrough`]'] }
      before do
        converter = Scrapbox2markdown::Converters::Strikethrough.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['~~`Strikethrough`~~']) }
    end

    context 'When an italic is in inline code' do
      subject(:lines) { ['`[- Strikethrough]`'] }
      before do
        converter = Scrapbox2markdown::Converters::Strikethrough.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['`[- Strikethrough]`']) }
    end

    context 'When an italic with extra characters is in inline code' do
      subject(:lines) { ['`Some[- Strikethrough]Thing`'] }
      before do
        converter = Scrapbox2markdown::Converters::Strikethrough.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['`Some[- Strikethrough]Thing`']) }
    end

    # １行の中にインライン（変換不可）と打ち消しが混在している場合
    context 'When an inline code and an strikethrough in the same line' do
      subject(:lines) { ['`[- Strikethrough]` ⇒ [- Strikethrough]'] }
      before do
        converter = Scrapbox2markdown::Converters::Strikethrough.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['`[- Strikethrough]` ⇒ ~~Strikethrough~~']) }
    end

    # １行の中にインライン（変換不可）と打ち消し（見出し）が混在している場合
    context 'When and inline code and an italic heading in the same line' do
      subject(:lines) { ['`[-*/ Strikethrough]` ⇒ [-* Strikethrough Heading]'] }
      before do
        converter = Scrapbox2markdown::Converters::Strikethrough.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['`[-*/ Strikethrough]` ⇒ ##### ~~Strikethrough Heading~~']) }
    end

    # １行の中にインライン（変換不可）と打ち消し（斜体見出し）が混在している場合
    context 'When and inline code and an strikethrough italic heading in the same line' do
      subject(:lines) { ['`[-*/ Strikethrough]` ⇒ [-*/ Strikethrough Italic Heading]'] }
      before do
        converter = Scrapbox2markdown::Converters::Strikethrough.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['`[-*/ Strikethrough]` ⇒ ##### ~~*Strikethrough Italic Heading*~~']) }
    end
  end
end
