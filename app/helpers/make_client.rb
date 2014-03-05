def make_twitter_client
  u = User.find(session[:user_id])
  @client = Twitter::Client.new(
      consumer_key: ENV['TWITTER_KEY'],
      consumer_secret: ENV['TWITTER_SECRET'],
      oauth_token: u.oauth_token,
      oauth_token_secret: u.oauth_secret)
end
