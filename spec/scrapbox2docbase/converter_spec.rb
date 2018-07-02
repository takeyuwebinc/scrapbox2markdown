RSpec.describe Scrapbox2docbase::Converter do
  describe '#convert!' do
    other = [
      "[* 打ち消し線]",
      " `[- 打ち消し]` ⇒ [- 打ち消し]",
      " `[-***/ 斜体太字打ち消し]` ⇒ [-***/ 斜体太字打ち消し]",
    ]

    code_block = [
      "code:サンプル.html",
      " <div id=\"js-sample_wrapper\" class=\"videostream-HD\" align=\"center\">",
      "     <video id=\"js-sample\" data-sample_video_id=\"sample\" class=\"video-js vjs-fluid vjs-default-skin vjs-big-play-centered\">",
      "     </video>",
      " </div>",
    ]

    table = [
      "table:Sample table",
      " Header1\tHeader2\tHeader3",
      " Row1-Cell1\tRow1-Cell2\tRow1-Cell3",
      " Row2-Cell1\tRow2-Cell2\tRow2-Cell3",
      " Row3-Cell1\tRow3-Cell2\tRow3-Cell3",
      "  This\tis\tthe end",
    ]

    expected_other = [
      "#### 打ち消し線",
      "- `[- 打ち消し]` ⇒ ~~打ち消し~~",
      "- `[-***/ 斜体太字打ち消し]` ⇒ ## ~~*斜体太字打ち消し*~~"
    ]

    expected_code_block = [
      "```サンプル.html",
      "<div id=\"js-sample_wrapper\" class=\"videostream-HD\" align=\"center\">",
      "    <video id=\"js-sample\" data-sample_video_id=\"sample\" class=\"video-js vjs-fluid vjs-default-skin vjs-big-play-centered\">",
      "    </video>",
      "</div>",
      "```",
    ]

    expected_table = [
      "- Sample table",
      "",
      "|Header1|Header2|Header3|",
      "|---|---|---|",
      "|Row1-Cell1|Row1-Cell2|Row1-Cell3|",
      "|Row2-Cell1|Row2-Cell2|Row2-Cell3|",
      "|Row3-Cell1|Row3-Cell2|Row3-Cell3|",
      "| This|is|the end|"
    ]

    lines_json = other + code_block + table
    lines_markdown = expected_other + expected_code_block + expected_table

    before do
      converter = Scrapbox2docbase::Converter.new(lines_json)
      converter.convert!
    end

    it 'should convert JSON to Markdown' do
      expect(lines_json).to eq lines_markdown
    end
  end
end
