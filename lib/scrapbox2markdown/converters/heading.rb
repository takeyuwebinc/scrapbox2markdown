module Scrapbox2markdown
  module Converters
    class Heading
      # [pattern, replace]
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

      # シンプルに見出しにするだけ
      # インラインコードのことは考慮しない
      def self.to_headings!(line)
        PATTERNS.each do |pattern|
          line.gsub!(pattern[0]) { |_| pattern[1] + $1 }
        end
      end

      private

      # [***** Heading] => # Heading
      def to_headings!(line, pattern, unmatch)
        convertibles = Scrapbox2markdown::Tokenizer.new(line, unmatch).convertible_tokens
        convertibles.each do |convertible|
          line.gsub!(convertible) { |match| match.sub(pattern[0]) { |_| pattern[1] + $1 }}
        end
      end
    end
  end
end
