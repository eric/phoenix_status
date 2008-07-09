require 'open-uri'

# 
# You can call in to this at (206) 357-6220 x12455
#
default do
  begin
    timeline = open('http://twitter.com/statuses/user_timeline/MarsPhoenix.json').read
    timeline = ActiveSupport::JSON.decode(timeline)
    timeline.reject! { |status| status['text'].match(/^@/) }

    text = timeline.first['text'].gsub('"', "'")

    execute 'swift', %{"Callie^#{text} ,, End Of Line."}
  rescue 
    execute 'swift', %{"Sorry, we weren't able to get the status for the Mars Phoenix project."}
    raise
  end
end
