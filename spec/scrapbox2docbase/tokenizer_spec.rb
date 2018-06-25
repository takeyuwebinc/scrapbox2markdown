RSpec.describe Scrapbox2docbase::Tokenizer do
  it 'returns an array of convertible strings' do
    line = 'インラインコード`[[ ]]`は変換されない'
    tokenizer = Scrapbox2docbase::Tokenizer.new(line, /`.*?`/)
    convertibles = tokenizer.convertible_tokens
    expect(convertibles).to match(['インラインコード', 'は変換されない'])
  end
end
