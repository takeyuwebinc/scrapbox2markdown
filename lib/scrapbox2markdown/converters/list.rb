module Scrapbox2markdown
  module Converters
    class List
      def initialize(lines)
        @lines = lines
      end

      def convert!
        @lines.each do |line|
          to_list!(line)
        end
      end

      private
      # ' List' #=> '- List'
      # '  List' #=> '  - List'
      # '   List' #=> '    - List'
      # 空白の数 + (1 * 空白の数-2) = リストマークより前の空白の数
      # 3 + (1 * (3-2)) = 4
      # 4 + (1 * (4-2)) = 6
      def to_list!(line)
        return line unless line.start_with?(/[[:blank:]]/)
        _, blank, str = line.partition(/^[[:blank:]]+/)
        list_mark = '-'
        case blank.size
        when 1
          list_mark = '-'
        when 2
          list_mark = '  -'
        else
          list_mark = ' ' * (blank.size + 1 * (blank.size-2)) + list_mark
        end
        line.replace("#{list_mark} #{str}")
      end
    end
  end
end
