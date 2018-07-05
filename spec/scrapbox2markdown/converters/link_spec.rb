RSpec.describe Scrapbox2markdown::Converters::Link do
  describe '#convert!' do
    describe 'Gyazo image' do
      response = {
        "version"=>"1.0",
        "type"=>"photo",
        "provider_name"=>"Gyazo",
        "provider_url"=>"https://gyazo.com",
        "url"=>"https://i.gyazo.com/5f93e65a3b979ae5333aca4f32600611.png",
        "width"=>209,
        "height"=>209,
        "scale"=>1.0
      }

      before do
        allow(Scrapbox2markdown::Gyazo).to receive(:get_response).and_return(response)
        converter = Scrapbox2markdown::Converters::Link.new(line)
        converter.convert!
      end

      context 'gyazo.com link only' do
        subject(:line) { ['[https://gyazo.com/5f93e65a3b979ae5333aca4f32600611]'] }
        # Converts to Markdown image
        it { is_expected.to match(['![](https://i.gyazo.com/5f93e65a3b979ae5333aca4f32600611.png)']) }
      end

      context 'gyazo.com link and no-blankets' do
        subject(:line) { ['[https://gyazo.com/5f93e65a3b979ae5333aca4f32600611] https://gyazo.com/5f93e65a3b979ae5333aca4f32600611'] }

        it { is_expected.to match(['![](https://i.gyazo.com/5f93e65a3b979ae5333aca4f32600611.png) https://gyazo.com/5f93e65a3b979ae5333aca4f32600611']) }
      end

      context 'gyazo.com link as inline code' do
        subject(:line) { ['`[https://gyazo.com/5f93e65a3b979ae5333aca4f32600611]`'] }

        it { is_expected.to match(['`[https://gyazo.com/5f93e65a3b979ae5333aca4f32600611]`']) }
      end
    end

    describe 'Gyazo GIF' do
      response = {
        "version"=>"1.0",
        "type"=>"photo",
        "provider_name"=>"Gyazo",
        "provider_url"=>"https://gyazo.com",
        "url"=>"https://i.gyazo.com/thumb/1000/b0c628a0c3645fa013c679571e9b5df1-gif.gif",
        "width"=>398,
        "height"=>266,
        "scale"=>1.0
      }

      subject(:line) { ['[https://gyazo.com/b0c628a0c3645fa013c679571e9b5df1]'] }

      before do
        allow(Scrapbox2markdown::Gyazo).to receive(:get_response).and_return(response)
        converter = Scrapbox2markdown::Converters::Link.new(line)
        converter.convert!
      end

      it { is_expected.to match(['![](https://i.gyazo.com/thumb/1000/b0c628a0c3645fa013c679571e9b5df1-gif.gif)']) }
    end


    describe 'Square blankets' do
      context 'Text only' do
        # Scrapboxの内部リンク
        subject(:line) { ['[Text]'] }
        before do
          converter = Scrapbox2markdown::Converters::Link.new(line)
          converter.convert!
        end

        it { is_expected.to match(['Text']) }
      end

      context 'Text with link' do
        # 外部リンク
        subject(:line) { ['[Text https://example.com]'] }
        before do
          converter = Scrapbox2markdown::Converters::Link.new(line)
          converter.convert!
        end
        # そのままテキストとリンクにする
        it { is_expected.to match(['Text https://example.com']) }
      end

      context 'Text with link in inline code' do
        subject(:line) { ['`[Text https://example.com]`'] }
        before do
          converter = Scrapbox2markdown::Converters::Link.new(line)
          converter.convert!
        end
        # インラインは変換しない
        it { is_expected.to match(['`[Text https://example.com]`']) }
      end

      context 'Text with link in inline code and the other inline' do
        subject(:line) { ['`[Text https://example.com]` and `Inline`'] }
        before do
          converter = Scrapbox2markdown::Converters::Link.new(line)
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
          converter = Scrapbox2markdown::Converters::Link.new(line)
          converter.convert!
        end

        it { is_expected.to match(['Hashtag']) }
      end

      context 'When #Hashtag in inline code' do
        subject(:line) { ['`#ハッシュタグ`'] }
        before do
          converter = Scrapbox2markdown::Converters::Link.new(line)
          converter.convert!
        end

        it { is_expected.to match(['`#ハッシュタグ`']) }
      end

      # '#'だけのものは変換しない。このパターンは滅多にないと思われるが・・・
      context 'When # only in inline code' do
        subject(:line) { ['`#`'] }
        before do
          converter = Scrapbox2markdown::Converters::Link.new(line)
          converter.convert!
        end

        it { is_expected.to match(['`#`']) }
      end
    end

    describe 'scrapbox.io links' do
      context 'When it is just a link' do
        subject(:line) { ['https://scrapbox.io/sample-project/サンプルページ'] }
        before do
          converter = Scrapbox2markdown::Converters::Link.new(line)
          converter.convert!
        end

        it { is_expected.to match(['']) }
      end

      context 'When it is with text' do
        subject(:line) { ['[こちらから トライアルを申し込めます https://scrapbox.io/enterprise]'] }
        before do
          converter = Scrapbox2markdown::Converters::Link.new(line)
          converter.convert!
        end

        it { is_expected.to match(['こちらから トライアルを申し込めます ']) }
      end
    end
  end
end
