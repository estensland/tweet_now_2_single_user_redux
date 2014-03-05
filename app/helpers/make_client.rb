def make_twitter_client
  puts "Make twitter user --------------"
  puts "session ID --------------"
  puts session[:user_id]
  puts "Twitter key --------------"
  puts ENV['TWITTER_KEY']
  puts "twitter secret --------------"
  puts ENV['TWITTER_SECRET']

  u = User.find(session[:user_id])
  puts "oauth token --------------"
  puts u.oauth_token
  puts "oauth secret--------------"
  puts u.oauth_secret


  @client = Twitter::Client.new(
      consumer_key: ENV['TWITTER_KEY'],
      consumer_secret: ENV['TWITTER_SECRET'],
      oauth_token: u.oauth_token,
      oauth_token_secret: u.oauth_secret)
end
