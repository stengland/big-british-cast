require 'sinatra/base'
require 'iplayer'

class BigBritishCast < Sinatra::Base
  set :app_file, __FILE__

  before do
    one_year_in_seconds = 31536000

#    headers 'Cache-Control'               => "public, max-age=#{one_year_in_seconds}",
            #'Expires'                     => (Time.now + one_year_in_seconds).httpdate,
            #'Access-Control-Allow-Origin' => '*'
  end

  helpers do
    def root_url
      url = "#{request.scheme}://#{request.host}"
      url << ":#{request.port}"if request.port != 80
      url
    end
  end

  get '/' do
    'Hello World'
  end

  get '/:title/feed.rss' do
    feed = Feedzirra::Feed.fetch_and_parse("http://feeds.bbc.co.uk/iplayer/bbc_radio_two/list")
    entries = feed.entries.select{|e| e.url =~ /#{params[:title]}/i}
    if entries.size > 0
      builder do |xml|
        xml.instruct! :xml, :version=>"1.0"
        xml.rss(:version=>"2.0") do
          xml.channel do
            xml.title(feed.title)
            xml.link(feed.url)
            xml.language('en-gb')
            for article in entries
              xml.item do
                xml.title(article.title)
                xml.description(article.content)
                xml.pubDate(article.published.rfc822)
                xml.link("#{root_url}/show/#{IPlayer::Downloader.extract_pid(article.url)}")
                xml.guid(article.url)
              end
            end
          end
        end
      end
    end
  end

  get '/show/:id' do
    downloader = IPlayer::Downloader.new IPlayer::Browser.new, params[:id]

    available_versions = downloader.available_versions
    raise IPlayer::MP4Unavailable if available_versions.empty?
    version = available_versions.first

    downloader.get(version.pid, File.join(settings.root, "tmp", params[:id])).read
  end
end