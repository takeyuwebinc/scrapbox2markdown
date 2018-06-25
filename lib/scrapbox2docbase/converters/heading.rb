module Scrapbox2docbase
  module Converters
    class Heading
      PATTERNS = [
          [/\[\*\*\*\*\*\s(.*?)\]/, '# '],
          [/\[\*\*\*\*\s(.*?)\]/, '## '],
          [/\[\*\*\*\s(.*?)\]/, '### '],
          [/\[\*\*\s(.*?)\]/, '##### '],
          [/\[\*\s(.*?)\]/, '##### '],
          [/\[\*{6,}\s(.*?)\]/, ''],
      ]

      def initialize(lines)
        @lines = lines
      end

      def convert!
        @lines.each do |line|
          PATTERNS.each do |pattern|
            # インラインコードは変換しない
            unmatch = /`.*#{pattern[0]}.*`/
            to_headings!(line, pattern, unmatch)
          end
        end
      end

      private

      # [***** Heading] => # Heading
      def to_headings!(line, pattern, unmatch)
        convertibles = Scrapbox2docbase::Tokenizer.new(line, unmatch).convertible_tokens
        convertibles.each { |convertible| convertible.gsub!(pattern[0]) { |_| pattern[1] + $1 } }
      end
    end
  end
end
