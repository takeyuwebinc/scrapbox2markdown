require 'strscan'
# インラインコードなど変換不要な語句が１行の中に存在し得る
# 渡された文字列をさらに分割し、変換可能な語句を取り出す
module Scrapbox2docbase
  class Tokenizer
    # @param [String] line
    # @param [Regexp] unmatch
    def initialize(line, unmatch)
      @line = line
      @unmatch = unmatch
      @convertibles = []
    end

    # @return [Array]
    def convertible_tokens
      tokenize(@line)
    end

    private
    # １行の中から変換しない部分を除いた語句を返す
    # @param [String] line
    # @return [Array]
    def tokenize(line)
      s = StringScanner.new(line)
      unconvertible = s.scan_until(@unmatch)
      # 変換不可な語句がなければ終了
      return @convertibles << line unless unconvertible
      # s.pre_matchが空文字ならば変換対象にはならない
      @convertibles << s.pre_match unless s.pre_match.empty?
      tokenize(s.rest)
    end
  end
end
