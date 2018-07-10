# Scrapbox2markdown

[Scrapbox](https://scrapbox.io/) からエクスポートしたJSONファイルを、記事ごとにマークダウンファイルに変換するツールです

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'scrapbox2markdown'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scrapbox2markdown

## Usage

### Converting to Markdown files

```sh
$ cd <scrapbox.ioからエクスポートしたJSONファイルがあるディレクトリ>
$ scrapbox2markdown --input sample.json --output path/to/output
```

カレントディレクトリ配下の`path/to/output` ディレクトリに変換されたマークダウンファイルが出力されます

### Importing to DocBase

出力されたマークダウンファイルを、DocBaseへインポートするスクリプト例です

```ruby
require 'json'
require 'net/http'
require 'time'
require 'yaml'


EXPORTED_DIR_PATH = 'マークダウンファイルを出力したディレクトリパス'
ACCESS_TOKEN = '自分のアクセストークン'
TEAM_DOMAIN = 'チームのドメイン'
GROUP_ID = 投稿先のグループID
# scrapboxにはタグという概念はないが、もし付けたい場合はこれも用意する
TAGS = ['タグ', 'tag']

BASE_URL       = URI.parse('https://api.docbase.io')
REQUEST_HEADER = {'X-DocBaseToken' => ACCESS_TOKEN, 'X-Api-Version' => 1, 'Content-Type' => 'application/json'}

def wait
  # 1時間に300回を超えるリクエストは無効のため待つ
  start_at = Time.now
  yield
  sleep_sec = [3600 / 300.0 - (Time.now - start_at), 0].max
  sleep(sleep_sec)
end

def post(request_path, data)
  http = Net::HTTP.new(BASE_URL.host, BASE_URL.port)
  http.use_ssl = BASE_URL.scheme == 'https'

  request = Net::HTTP::Post.new(request_path)
  request.body = data
  REQUEST_HEADER.each { |key, value| request.add_field(key, value) }

  response = http.request(request)
  response_body = JSON.parse(response.body)

  if response.code == '201'
    response_body
  else
    message = response_body['messages'].join("\n")
    puts "Error: #{message}"
    nil
  end
end

Dir.glob "#{EXPORTED_DIR_PATH}/**/*.md" do |path|
  open path do |file|
    text = file.read

    data = YAML.load(text)
    body = text.sub(/\A---$.*?^---$/m, '')

    post_json = {
        title:  "#{data['title']}",
        body:   body.delete_prefix!("\n\n"), # 行頭に改行が２つ入ってしまうので削除
        tags:   TAGS, # タグを付けない場合はこれは不要
        scope:  'group',
        groups: [GROUP_ID],
        draft:  false,
        notice: false,
        published_at: data['created_at'].iso8601,
    }.to_json

    wait do
      print "Create post "
      created_post = post("/teams/#{TEAM_DOMAIN}/posts", post_json)
      puts created_post['url'] if created_post
    end
  end
end
```

こちらのスクリプト例を参考にしています (https://help.docbase.io/posts/46870)

`publish_at` パラメータの使用には、APIの利用者がチームのオーナー、もしくは管理者である必要があります
詳しくはこちら (https://help.docbase.io/posts/216289)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/scrapbox2markdown.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
