
require 'drb'
require 'activesupport'
require 'open-uri'

PHONE_NUMBER = '12063787668'
TWITTER_USER = 'MarsPhoenix'
AGI_URL = 'agi://alien.5stops.com:4574/default'

class TwitterWatch
  attr_reader :thread, :username

  def initialize(username, poll_interval = 2.minutes)
    @username = username
    @poll_interval = poll_interval.to_i
  end

  def on_update(&block)
    catch(:finished) do
      loop do
        if tweet_id = get_latest_tweet_id
          if @last_tweet_id && @last_tweet_id != tweet_id
            puts "New tweet id: #{tweet_id}"
            block.call
          end
          @last_tweet_id = tweet_id
        end

        sleep @poll_interval
      end
    end
  end

  protected
  def get_latest_tweet_id
    timeline = open("http://twitter.com/statuses/user_timeline/#{@username}.json").read
    timeline = ActiveSupport::JSON.decode(timeline)
    timeline.reject! { |status| status['text'].match(/^@/) }

    timeline[0]['id']
  rescue Exception => e
    puts "#{e.class}: #{e.message}"
    nil
  end
end

Adhearsion = DRbObject.new_with_uri('druby://localhost:48370')
tw = TwitterWatch.new(TWITTER_USER)

tw.on_update do
  Adhearsion.proxy.call_and_exec "Local/#{PHONE_NUMBER}@outgoing-9", 'Agi', :args => AGI_URL
end

