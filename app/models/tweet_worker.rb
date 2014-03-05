class TweetWorker
  include Sidekiq::Worker

  def perform(tweet_id)


    tweet = Tweet.find(tweet_id)
    user  = tweet.user

    # set up Twitter OAuth client here
    # actually make API call
    # Note: this does not have access to controller/view helpers
    # You'll have to re-initialize everything inside here


    @client = Twitter::REST::Client.new(
      consumer_key: ENV['TWITTER_KEY'],
      consumer_secret: ENV['TWITTER_SECRET'],
      oauth_token: user.oauth_token,
      oauth_token_secret: user.oauth_secret)


    @client.update(tweet.message)

  end
end
