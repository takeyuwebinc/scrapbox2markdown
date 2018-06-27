RSpec.describe Scrapbox2docbase::Converters::Emphasis do
  describe '#convert!' do
    context 'When passing a single line' do
      subject(:line) { ['[[Emphasis]]'] }
      before do
        converter = Scrapbox2docbase::Converters::Emphasis.new(line)
        converter.convert!
      end

      it { is_expected.to match(['**Emphasis**']) }
    end

    context 'When passing a single line including a multiple emphasis' do
      subject(:line) { ['[[First]] [[Second]]'] }
      before do
        converter = Scrapbox2docbase::Converters::Emphasis.new(line)
        converter.convert!
      end

      it { is_expected.to match(['**First** **Second**']) }
    end

    context 'When passing a multiple line' do
      subject(:lines) { ['[[Emphasis]]', 'and', '[[PLAIN_TEXT]]'] }
      before do
        converter = Scrapbox2docbase::Converters::Emphasis.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['**Emphasis**', 'and', '**PLAIN_TEXT**']) }
    end

    context 'When a line includes an inline code' do
      subject(:lines) { ['[[`Emphasis`]]'] }
      before do
        converter = Scrapbox2docbase::Converters::Emphasis.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['**`Emphasis`**']) }
    end

    context 'When a heading is in inline code' do
      subject(:lines) { ['`[[Emphasis]]`'] }
      before do
        converter = Scrapbox2docbase::Converters::Emphasis.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['`[[Emphasis]]`']) }
    end

    context 'When an emphasis with extra characters is in inline code' do
      subject(:lines) { ['`Some[[Emphasis]]Thing`'] }
      before do
        converter = Scrapbox2docbase::Converters::Emphasis.new(lines)
        converter.convert!
      end

      it { is_expected.to match(['`Some[[Emphasis]]Thing`']) }
    end
  end
end
