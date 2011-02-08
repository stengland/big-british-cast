require 'big-british-cast'  # <-- your sinatra app
require 'feedzirra'
require 'iplayer'
require 'rack/test'

describe 'The HelloWorld App' do
  include Rack::Test::Methods

  def app
    BigBritishCast
  end

  it "says hello" do
    get '/'
    last_response.should be_ok
    last_response.body.should == 'Hello World'
  end

  it "feeds me bruce" do
    get "/Ken_Bruce/feed.rss"
    last_response.should be_ok
  end

  it "should alow me to doanload a file" do
    feed = Feedzirra::Feed.fetch_and_parse("http://feeds.bbc.co.uk/iplayer/bbc_radio_two/list")
    article = feed.entries.find{|e| e.url =~ /Ken_Bruce/}
    get "/show/#{IPlayer::Downloader.extract_pid(article.url)}"

    last_response.should be_ok
  end
end
