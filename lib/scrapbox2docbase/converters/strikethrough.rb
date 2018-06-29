module Scrapbox2docbase
  module Converters
    class Strikethrough
      PATTERNS = {
        strikethrough: /\[\-\s(.+?)\]/,
        strikethrough_heading: /\[\-(?<stars>\*+)+\s(?<str>.+?)\]/,
        strikethrough_italic_heading: /\[\-(?<stars>\*+)\/+\s(?<str>.+?)\]/,
      }

      def initialize(lines)
        @lines = lines
      end

      def convert!
        @lines.each do |line|
          to_strikethrough!(line, PATTERNS[:strikethrough], /`.*?#{PATTERNS[:strikethrough]}.*?`/)
          to_strikethrough_heading!(line, PATTERNS[:strikethrough_heading],/`.*#{PATTERNS[:strikethrough_heading]}.*`/)
          to_strikethrough_italic_heading!(line, PATTERNS[:strikethrough_italic_heading],/`.*#{PATTERNS[:strikethrough_italic_heading]}.*`/)
        end
      end

      private
      # 打ち消し
      # [- Strikethrough] #=> ~~Strikethrough~~
      def to_strikethrough!(line, pattern, unmatch)
        # 変換可能な語句を取り出す
        convertibles = Scrapbox2docbase::Tokenizer.new(line, unmatch).convertible_tokens
        convertibles.each do |convertible|
          # 大元のlineからconvertibleにマッチする部分を取り出し、置換する
          line.gsub!(convertible) { |match| match.gsub(pattern, "~~"+'\1'+"~~") }
        end
      end

      # 見出し打ち消し
      # [-*/ Strikethrough Heading] #=> ##### ~~*Strikethrough Heading*~~
      def to_strikethrough_heading!(line, pattern, unmatch)
        convertibles = Scrapbox2docbase::Tokenizer.new(line, unmatch).convertible_tokens
        convertibles.each do |convertible|
          # まずこれ[* ~~Strikethrough Heading~~]に変換
          # 大元のlineからconvertibleにマッチする部分を取り出し、置換する
          line.gsub!(convertible) { |match| match.gsub(pattern, '[\k<stars> ~~\k<str>~~]') }
          # Scrapbox2docbase::Converters::Heading.to_headings! で見出しに変換
          Scrapbox2docbase::Converters::Heading.to_headings!(line)
        end
      end

      # 斜体見出し打ち消し
      # [-*/ Strikethrough Italic Heading] #=> ##### ~~*Strikethrough Italic Heading*~~
      def to_strikethrough_italic_heading!(line, pattern, unmatch)
        convertibles = Scrapbox2docbase::Tokenizer.new(line, unmatch).convertible_tokens
        convertibles.each do |convertible|
          # まずこれ[* ~~*Strikethrough Italic Heading*~~]に変換
          # 大元のlineからconvertibleにマッチする部分を取り出し、置換する
          line.gsub!(convertible) { |match| match.gsub(pattern, '[\k<stars> ~~*\k<str>*~~]') }
          # Scrapbox2docbase::Converters::Heading.to_headings! で見出しに変換
          Scrapbox2docbase::Converters::Heading.to_headings!(line)
        end
      end
    end
  end
end
