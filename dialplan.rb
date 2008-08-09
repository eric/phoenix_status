require 'open-uri'

# 
# You can call in to this at (206) 357-6220 x12455
#
default do
  begin
    twitter_user ||= 'MarsPhoenix'
    timeline = open("http://twitter.com/statuses/user_timeline/#{twitter_user}.json").read
    timeline = ActiveSupport::JSON.decode(timeline)
    timeline.reject! { |status| status['text'].match(/^@/) }

    text = timeline.first['text'].gsub('"', "'")

    execute 'swift', %{"Callie^There's been a new tweet!  Here's what it says: ,, #{text} ,,, Good bye."}
  rescue 
    execute 'swift', %{"Sorry, we weren't able to get the newest tweet.  Please try again later."}
    raise
  end
end
