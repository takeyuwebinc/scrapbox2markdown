module Scrapbox2docbase
  module Converters
    class Link
      # pattern, unmatch
      PATTERNS = {
        hashtag: [/\#{1}(.+?)\b/, /(`\#{1}(.+?)\b`|`.+?`)/], # `#`だけのものなど、インライン内の文字`.+?`は除外
        square_blanket: [/\[{1}(.+?)\]/, /`\[{1}(.+?)\]`/],
        scrapbox_link: [/https:\/\/scrapbox.io\/\S+/, /`https:\/\/scrapbox.io\/\S+`/]
      }

      def initialize(lines)
        @lines = lines
      end

      def convert!
        @lines.each do |line|
          remove_hashtags!(line, PATTERNS[:hashtag][0], PATTERNS[:hashtag][1])
          remove_square_blankets!(line, PATTERNS[:square_blanket][0], PATTERNS[:square_blanket][1])
          remove_scrapbox_links!(line, PATTERNS[:scrapbox_link][0], PATTERNS[:scrapbox_link][1])
        end
      end

      private

      # TODO: そもそもScrapboxの内部リンクなら、テキストごと削除しても問題ない？
      def remove_hashtags!(line, pattern, unmatch)
        convertibles = Scrapbox2docbase::Tokenizer.new(line, unmatch).convertible_tokens
        convertibles.each do |convertible|
          line.gsub!(convertible) { |match| match.gsub(pattern) { |_| $1 } }
        end
      end

      # TODO: テキストのみなら削除しても良い？
      # []で囲まれるとScrapbox内の別ページへのリンクになる それらを除去する
      # [Text https://example.com], [Text]など色々なパターンがあるが単純に[]を除去
      def remove_square_blankets!(line, pattern, unmatch)
        convertibles = Scrapbox2docbase::Tokenizer.new(line, unmatch).convertible_tokens
        convertibles.each do |convertible|
          line.gsub!(convertible) { |match| match.gsub(pattern) { |_| $1 } }
        end
      end

      # TODO: これもScrapboxのリンクなのでテキストごと削除しても良い？
      def remove_scrapbox_links!(line, pattern, unmatch)
        convertibles = Scrapbox2docbase::Tokenizer.new(line, unmatch).convertible_tokens
        convertibles.each do |convertible|
          line.gsub!(convertible) { |_| line.gsub(pattern, '') }
        end
      end
    end
  end
end
