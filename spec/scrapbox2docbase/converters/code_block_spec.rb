RSpec.describe Scrapbox2docbase::Converters::CodeBlock do
  describe '#convert!' do
    context 'When passing a multiple line' do
      subject(:lines) { [
        "code:サンプル.html",
        " <link href=\"https://scrapbox2docbase/test.min.css\" rel=\"stylesheet\">",
        " <script src=\"https://scrapbox2docbase/test.min.js\"></script>",
        " ",
        " <div id=\"js-sample_wrapper\" class=\"videostream-HD\" align=\"center\">",
        "     <video id=\"js-sample\" data-sample_video_id=\"sample\" class=\"video-js vjs-fluid vjs-default-skin vjs-big-play-centered\">",
        "     </video>",
        " </div>",
        " <script type=\"text/javascript\">SamplePlayer('js-sample');</script>"
      ]}

      before do
        converter = Scrapbox2docbase::Converters::CodeBlock.new(lines)
        converter.convert!
      end

      # マークダウン形式のコードブロックに変換するが、最後の閉じる```は挿入しない
      # Scrapbox2docbase::Converter#code_blockにて挿入する
      expected = [
          "```サンプル.html",
          "<link href=\"https://scrapbox2docbase/test.min.css\" rel=\"stylesheet\">",
          "<script src=\"https://scrapbox2docbase/test.min.js\"></script>",
          "",
          "<div id=\"js-sample_wrapper\" class=\"videostream-HD\" align=\"center\">",
          "    <video id=\"js-sample\" data-sample_video_id=\"sample\" class=\"video-js vjs-fluid vjs-default-skin vjs-big-play-centered\">",
          "    </video>",
          "</div>",
          "<script type=\"text/javascript\">SamplePlayer('js-sample');</script>",
      ]

      it { is_expected.to match(expected) }
    end
  end
end
