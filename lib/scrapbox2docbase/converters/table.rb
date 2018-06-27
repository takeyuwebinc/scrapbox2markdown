module Scrapbox2docbase
  module Converters
    class Table
      # @param [Array] lines
      def initialize(lines)
        @lines = lines
      end

      def convert!
        @lines[1..-1].each do |line|
          to_row!(line)
        end
        # 0番目の行はタイトルに変換
        to_title!(@lines.first)
      end

      private

      # タイトルの変換、リストにする
      # Before: table:サンプル
      # After: - サンプル
      def to_title!(line)
        line.sub!('table:', '- ')
      end

      # Before: " Cell1\tCell2\tCell3"
      # After: "|Cell1|Cell2|Cell3|"
      def to_row!(line)
        return unless line.start_with?(/[[:space:]]/)
        # 行頭、タブ、行末を変換
        line[0] = '|'
        line.gsub!(/\t/, '|')
        line.concat('|')
      end
    end
  end
end
