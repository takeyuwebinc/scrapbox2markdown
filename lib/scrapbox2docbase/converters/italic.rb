module Scrapbox2docbase
  module Converters
    class Italic
      PATTERNS = {
        italic: /\[\/\s(.+?)\]/,
        italic_heading: /\[\/\*+\s(.+?)\]/,
      }

      def initialize(lines)
        @lines = lines
      end

      def convert!
        @lines.each do |line|
          to_italic!(line, PATTERNS[:italic], /`.*?#{PATTERNS[:italic]}.*?`/)
          to_italic_heading!(line, PATTERNS[:italic_heading],/`.*#{PATTERNS[:italic_heading]}.*`/)
        end
      end

      private
      # 斜体文字
      # [/ Italic] #=> *Italic*
      def to_italic!(line, pattern, unmatch)
        # 変換可能な語句を取り出す
        convertibles = Scrapbox2docbase::Tokenizer.new(line, unmatch).convertible_tokens
        convertibles.each do |convertible|
          # 大元のlineからconvertibleにマッチする部分を取り出し、置換する
          line.gsub!(convertible) { |match| match.gsub(pattern, "*"+'\1'+"*") }
        end
      end

      # 斜体見出し
      # [/* Italic] #=> ##### *Italic*
      def to_italic_heading!(line, pattern, unmatch)
        convertibles = Scrapbox2docbase::Tokenizer.new(line, unmatch).convertible_tokens
        convertibles.each do |convertible|
          # まずこれ[* *Italic*]に変換
          # 大元のlineからconvertibleにマッチする部分を取り出し、置換する
          line.gsub!(convertible) { |match| match.gsub(pattern, '[* *'+'\1'+'*]') }
          # Scrapbox2docbase::Converters::Heading.to_headings! で見出しに変換
          Scrapbox2docbase::Converters::Heading.to_headings!(line)
        end
      end
    end
  end
end
