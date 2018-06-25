RSpec.describe Scrapbox2docbase::Converter do

  other = [
    "[* 打ち消し線]",
    " `[- 打ち消し]` ⇒ [- 打ち消し]",
    " `[-***/ 斜体太字打ち消し]` ⇒ [-***/ 斜体太字打ち消し]",
  ]

  code_blocks_one = [
    "code:サンプル.html",
    " <link href=\"https://scrapbox2docbase/test.min.css\" rel=\"stylesheet\">",
    " <script src=\"https://scrapbox2docbase/test.min.js\"></script>",
    " ",
    " <div id=\"js-sample_wrapper\" class=\"videostream-HD\" align=\"center\">",
    "     <video id=\"js-sample\" data-sample_video_id=\"sample\" class=\"video-js vjs-fluid vjs-default-skin vjs-big-play-centered\">",
    "     </video>",
    " </div>",
    " <script type=\"text/javascript\">SamplePlayer('js-sample');</script>",
  ]

  code_blocks_two = [
    "code:bash",
    " TEST_ENV=test this is a test command",
  ]

  let(:lines) { other + code_blocks_one + code_blocks_two }

  it 'should returns an array of a first code blocks(String)' do
    code_blocks = Scrapbox2docbase::Converter.new(lines).code_block
    expect(code_blocks).to match(code_blocks_one)
  end

  it 'should returns an array of other lines(String)' do
    others = Scrapbox2docbase::Converter.new(lines).others
    expect(others).to match(other)
  end
end
