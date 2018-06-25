module Scrapbox2docbase
  module Converters
    class CodeBlock
      # @param [Array] lines
      def initialize(lines)
        @lines = lines
      end

      def convert!
        # コードブロックの開始行(code:sample.html)を変換する
        convert_first_line!(@lines.first)
        # コードブロックの２行目からコード本文が始まる
        @lines[1..-1].each do |line|
          reindent_code_block!(line)
        end
      end

      private

      # Before: code:サンプル.html
      # After: ```サンプル.html
      def convert_first_line!(line)
        line.sub!('code:', '```')
      end

      # Scrapboxではコードブロック内の行は半角空白１文字でインデントされている
      # よって行頭の空白を1文字削除する
      def reindent_code_block!(line)
        line.delete_prefix!(' ')
      end
    end
  end
end
