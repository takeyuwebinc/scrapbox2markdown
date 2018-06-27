module Scrapbox2docbase
  module Converters
    class Emphasis
      PATTERN = /\[{2}.*?\]{2}/

      def initialize(lines)
        @lines = lines
      end

      def convert!
        @lines.each do |line|
          # インラインコードは変換しない
          # e.g. `このような[[場合でも]]変換しない`
          unmatch = /`.*#{PATTERN}.*`/
          to_emphasis!(line, PATTERN, unmatch)
        end
      end

      private

      # [[Emphasis]] #=> **Emphasis**
      # [* Emphasis] #=> **Emphasis** これは一番小さい見出し'##### Emphasis'に該当、見出し変換で対応可
      def to_emphasis!(line, pattern, unmatch)
        convertibles = Scrapbox2docbase::Tokenizer.new(line, unmatch).convertible_tokens
        convertibles.each { |convertible| convertible.gsub!(pattern) { |match| match.gsub(/\[{2}|\]{2}/, '**') } }
      end
    end
  end
end
