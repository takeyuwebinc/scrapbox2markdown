module Scrapbox2docbase
  class Converter
    # @param [Array] lines
    def initialize(lines)
      @lines = lines
    end

    def convert!
      # コードブロック以外の全てのサブコンバータに渡す
      Scrapbox2docbase::Converters::Heading.new(others).convert! unless others.empty?

      # 最後に'```'を追加することにより行番号がずれるので、１つずつコードブロックの変換を行う
      while has_code_block?
        Scrapbox2docbase::Converters::CodeBlock.new(code_block).convert!
      end
    end

    # @return [Array] コードブロックの行をはじめの１つだけ取り出す
    def code_block
      # e.g. {:code_block=>[59, 60, 61, 62, 63, 64, 65, 66, 67]}
      # TODO: ここはhashで返す必要はないのでは
      hash = Scrapbox2docbase::Detector.new(@lines).line_numbers_of_code_block
      # 先にコードブロックを閉じる```を追加しておく
      # Converters::CodeBlock内で挿入しようとしてもダメだった
      @lines.insert(hash[:code_block].last + 1, '```')
      hash[:code_block].map { |number| @lines[number] }
    end

    # @return [Array] コードブロックやテーブル以外の行
    def others
      # e.g. {:others=>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]}
      # TODO: ここはhashで返す必要はないのでは
      hash = Scrapbox2docbase::Detector.new(@lines).line_numbers_of_others
      hash[:others].map { |number| @lines[number] }
    end

    private

    def has_code_block?
      hash = Scrapbox2docbase::Detector.new(@lines).line_numbers_of_code_block
      !hash[:code_block].empty?
    end
  end
end
