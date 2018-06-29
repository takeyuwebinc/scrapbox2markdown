RSpec.describe Scrapbox2docbase::Converters::Link do
  describe '#convert!' do
    describe 'Square blankets' do
      context 'Text only' do
        # Scrapboxの内部リンク
        subject(:line) { ['[Text]'] }
        before do
          converter = Scrapbox2docbase::Converters::Link.new(line)
          converter.convert!
        end

        it { is_expected.to match(['Text']) }
      end

      context 'Text with link' do
        # 外部リンク
        subject(:line) { ['[Text https://example.com]'] }
        before do
          converter = Scrapbox2docbase::Converters::Link.new(line)
          converter.convert!
        end
        # そのままテキストとリンクにする
        it { is_expected.to match(['Text https://example.com']) }
      end

      context 'Text with link in inline code' do
        subject(:line) { ['`[Text https://example.com]`'] }
        before do
          converter = Scrapbox2docbase::Converters::Link.new(line)
          converter.convert!
        end
        # インラインは変換しない
        it { is_expected.to match(['`[Text https://example.com]`']) }
      end

      context 'Text with link in inline code and the other inline' do
        subject(:line) { ['`[Text https://example.com]` and `Inline`'] }
        before do
          converter = Scrapbox2docbase::Converters::Link.new(line)
          converter.convert!
        end
        # インラインは変換しない
        it { is_expected.to match(['`[Text https://example.com]` and `Inline`']) }
      end
    end

    describe 'Hashtag' do
      # 内部リンク
      context 'When #Hashtag only' do
        subject(:line) { ['#Hashtag'] }
        before do
          converter = Scrapbox2docbase::Converters::Link.new(line)
          converter.convert!
        end

        it { is_expected.to match(['Hashtag']) }
      end

      context 'When #Hashtag in inline code' do
        subject(:line) { ['`#ハッシュタグ`'] }
        before do
          converter = Scrapbox2docbase::Converters::Link.new(line)
          converter.convert!
        end

        it { is_expected.to match(['`#ハッシュタグ`']) }
      end

      # '#'だけのものは変換しない。このパターンは滅多にないと思われるが・・・
      context 'When # only in inline code' do
        subject(:line) { ['`#`'] }
        before do
          converter = Scrapbox2docbase::Converters::Link.new(line)
          converter.convert!
        end

        it { is_expected.to match(['`#`']) }
      end
    end

    describe 'scrapbox.io links' do
      context 'When it is just a link' do
        subject(:line) { ['https://scrapbox.io/sample-project/サンプルページ'] }
        before do
          converter = Scrapbox2docbase::Converters::Link.new(line)
          converter.convert!
        end

        it { is_expected.to match(['']) }
      end

      context 'When it is with text' do
        subject(:line) { ['[こちらから トライアルを申し込めます https://scrapbox.io/enterprise]'] }
        before do
          converter = Scrapbox2docbase::Converters::Link.new(line)
          converter.convert!
        end

        it { is_expected.to match(['こちらから トライアルを申し込めます ']) }
      end
    end
  end
end
