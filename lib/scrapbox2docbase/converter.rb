module Scrapbox2docbase
  class Converter
    # @param [Array] lines
    def initialize(lines)
      @lines = lines
    end

    def convert!
      # コードブロック以外の全てのサブコンバータに渡す
      # e.g. {:others=>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]}
      # TODO: ここはhashで返す必要はないのでは
      hash = Scrapbox2docbase::Detector.new(@lines).line_numbers_of_others
      others = hash[:others].map { |number| @lines[number] }
      Scrapbox2docbase::Converters::Heading.new(others).convert! unless others.empty?

      # 最後に'```'を追加することにより行番号がずれるので、１つずつコードブロックの変換を行う
      while has_code_block?
        # e.g. {:code_block=>[59, 60, 61, 62, 63, 64, 65, 66, 67]}
        # TODO: ここはhashで返す必要はないのでは
        hash = Scrapbox2docbase::Detector.new(@lines).line_numbers_of_code_block
        code_block = hash[:code_block].map { |number| @lines[number] }
        Scrapbox2docbase::Converters::CodeBlock.new(code_block).convert!

        # 追加処理、Converters::CodeBlock内で挿入しようとしてもダメだった
        # コードブロックを閉じる```を追加
        @lines.insert(hash[:code_block].last + 1, '```')
      end

      # マークダウンへ変換することにより行番号がずれるので、１つずつテーブルの変換を行う
      while has_table?
        # e.g. {:table=>[59, 60, 61, 62, 63, 64, 65, 66, 67]}
        # TODO: ここはhashで返す必要はないのでは
        hash = Scrapbox2docbase::Detector.new(@lines).line_numbers_of_table
        table = hash[:table].map { |number| @lines[number] }
        Scrapbox2docbase::Converters::Table.new(table).convert!

        # 追加処理、Converters::Table内ではダメだった
        # セルの数を調べ、それに合わせテーブルの形式を作成、最初の行(1番目)の下に挿入
        cells = @lines[hash[:table][1]].count('|') - 1
        @lines.insert(hash[:table][2], "#{'|---' * cells}|")
        # titleの下に空行を入れ、テーブル本体と離す
        @lines.insert(hash[:table][1], '')
      end
    end

    private

    def has_code_block?
      hash = Scrapbox2docbase::Detector.new(@lines).line_numbers_of_code_block
      !hash[:code_block].empty?
    end

    def has_table?
      hash = Scrapbox2docbase::Detector.new(@lines).line_numbers_of_table
      !hash[:table].empty?
    end
  end
end
