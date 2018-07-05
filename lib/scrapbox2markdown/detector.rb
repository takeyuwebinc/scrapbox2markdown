module Scrapbox2markdown
  class Detector
    def initialize(lines)
      @lines = lines
      @line_numbers = (0..(lines.size-1)).to_a
    end

    # @return [Hash] コードブロックやテーブル以外の行番号
    # e.g. { others: [0, 1, 2, 10, 11, 12] }
    def line_numbers_of_others
      others = @line_numbers
      if !beginnings_of_code_block.empty?
        others = others - line_numbers_of_code_blocks.values.flatten
      end
      if !beginnings_of_table.empty?
        others = others - line_numbers_of_tables.values.flatten
      end
      { others: others }
    end

    # @return [Hash] ファイルの先頭から、１番はじめのコードブロックの行番号
    # e.g. { code_block: [0, 1, 2] }
    def line_numbers_of_code_block
      return { code_block: [] } if beginnings_of_code_block.empty?
      beginning = beginnings_of_code_block.first
      { code_block: indexes_of_code_block(beginning) }
    end

    # @return [Hash] コードブロックの行番号(複数)
    # e.g. { code_blocks: [[0, 1, 2], [10, 11, 12]] }
    def line_numbers_of_code_blocks
      code_blocks = []
      beginnings_of_code_block.each do |beginning|
        code_blocks << indexes_of_code_block(beginning)
      end
      { code_blocks: code_blocks }
    end

    # @return [Hash] ファイルの先頭から、１番はじめのテーブルの行番号
    # e.g. { table: [0, 1, 2] }
    def line_numbers_of_table
      return { table: [] } if beginnings_of_table.empty?
      beginning = beginnings_of_table.first
      { table: indexes_of_table(beginning) }
    end

    # @return [Hash] テーブルの行番号(複数)
    # e.g. { tables: [[0, 1, 2], [10, 11, 12]] }
    def line_numbers_of_tables
      tables = []
      beginnings_of_table.each do |beginning|
        tables << indexes_of_table(beginning)
      end
      { tables: tables }
    end

    private

    # コードブロックの次の行からコードブロックであるかどうかを検出し、インデックスを返す
    def indexes_of_code_block(beginning)
      code_block_indexes = [beginning]
      (beginning+1).step do |line_number|
        break unless code_block?(@lines[line_number])
        code_block_indexes << line_number
      end
      # 開始行の行番号も含めたインデックスの配列を返す
      code_block_indexes
    end

    def beginnings_of_code_block
      beginnings = []
      @lines.each.with_index do |line, i|
        beginnings << i if line.start_with?('code:')
      end
      # e.g. [0, 9]
      beginnings
    end

    # コードブロックであるかどうかを検知
    # 開始行は含めない
    def code_block?(line)
      !line&.start_with?('code:') && line&.start_with?(/[[:space:]]/)
    end

    # テーブルの次の行からテーブルであるかどうかを検出し、インデックスを返す
    def indexes_of_table(beginning)
      table_indexes = [beginning]
      (beginning+1).step do |line_number|
        break unless table?(@lines[line_number])
        table_indexes << line_number
      end
      # 開始行の行番号も含めたインデックスの配列を返す
      table_indexes
    end

    def beginnings_of_table
      beginnings = []
      @lines.each.with_index do |line, i|
        beginnings << i if line.start_with?('table:')
      end
      # e.g. [0, 9]
      beginnings
    end

    # テーブルであるかどうかを検知
    # 開始行は含めない
    def table?(line)
      !line&.start_with?('table:') && line&.start_with?(/[[:space:]]/)
    end
  end
end
