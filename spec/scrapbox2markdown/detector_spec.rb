RSpec.describe Scrapbox2markdown::Detector do
  let(:code_blocks) { [
      "code:サンプル.html",
      " <link href=\"https://scrapbox2markdown/test.min.css\" rel=\"stylesheet\">",
      " <script src=\"https://scrapbox2markdown/test.min.js\"></script>",
      " ",
      " <div id=\"js-sample_wrapper\" class=\"videostream-HD\" align=\"center\">",
      "     <video id=\"js-sample\" data-sample_video_id=\"sample\" class=\"video-js vjs-fluid vjs-default-skin vjs-big-play-centered\">",
      "     </video>",
      " </div>",
      " <script type=\"text/javascript\">SamplePlayer('js-sample');</script>",
      "code:bash",
      " TEST_ENV=test this is a test command",
  ] }

  let(:other) { [
      "[* 打ち消し線]",
      " `[- 打ち消し]` ⇒ [- 打ち消し]",
      " `[-***/ 斜体太字打ち消し]` ⇒ [-***/ 斜体太字打ち消し]",
  ] }

  let(:tables) { [
      "table:Sample table",
      " Header1\tHeader2\tHeader3",
      " Row1-Cell1\tRow1-Cell2\tRow1-Cell3",
      " Row2-Cell1\tRow2-Cell2\tRow2-Cell3",
      " Row3-Cell1\tRow3-Cell2\tRow3-Cell3",
      "  This\tis\tthe end",
      "table:Sample table2",
      " Header1\tHeader2\tHeader3",
      " Row1-Cell1\tRow1-Cell2\tRow1-Cell3",
      " Row2-Cell1\tRow2-Cell2\tRow2-Cell3",
      " Row3-Cell1\tRow3-Cell2\tRow3-Cell3",
      "  This\tis\tthe end",
  ] }

  describe '#line_numbers_of_code_blocks' do
    it 'should detect indexes of code blocks' do
      detector = Scrapbox2markdown::Detector.new(code_blocks)
      code_blocks = detector.line_numbers_of_code_blocks
      expect(code_blocks).to match(code_blocks: [[0, 1, 2, 3, 4, 5, 6, 7, 8], [9, 10]])
    end
  end

  describe '#line_numbers_of_others' do
    context 'When passing normal lines' do
      it 'should detect indexes of normal lines' do
        detector = Scrapbox2markdown::Detector.new(other)
        others = detector.line_numbers_of_others
        expect(others).to match(others: [0, 1, 2])
      end
    end

    context 'When passing normal lines + code blocks' do
      let(:others_and_code_blocks) { other + code_blocks }

      it 'should detect indexes of normal lines only' do
        detector = Scrapbox2markdown::Detector.new(others_and_code_blocks)
        others = detector.line_numbers_of_others
        expect(others).to match(others: [0, 1, 2])
      end
    end

    context 'When passing normal lines + tables' do
      let(:others_and_code_blocks) { other + tables }

      it 'should detect indexes of normal lines only' do
        detector = Scrapbox2markdown::Detector.new(others_and_code_blocks)
        others = detector.line_numbers_of_others
        expect(others).to match(others: [0, 1, 2])
      end
    end
  end

  describe '#line_numbers_of_tables' do
    it 'should detect indexes of tables' do
      detector = Scrapbox2markdown::Detector.new(tables)
      tables = detector.line_numbers_of_tables
      expect(tables).to match(tables: [[0, 1, 2, 3, 4, 5], [6, 7, 8, 9, 10, 11]])
    end
  end
end
