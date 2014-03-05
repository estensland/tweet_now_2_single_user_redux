get '/' do
  if session[:user_id]
    @user = User.find(session[:user_id])
    erb :index
  else
    erb :index
  end
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  session[:access_token] = @access_token

  puts "Params"
  p params

  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)

  # at this point in the code is where you'll need to create your user account and store the access token

  # grab twitter username
  # find or create twitter username (Doesn't seem to work. Why?)
  # @user = User.find_by(username: @access_token.params[:screen_name]) || User.create(username: @access_token.params[:screen_name])
  # update user record with obtained access token & access token secret
  @user = User.find_or_create_by(username: @access_token.params[:screen_name])
  @user.update_attributes( oauth_token: @access_token.params[:oauth_token], oauth_secret: @access_token.params[:oauth_token_secret])
  # set session[:user_id] with User.id (logged in)
  session[:user_id] = @user.id
  # render tweet form

  redirect to '/'
  # erb :index

end

post '/tweet' do
  # call helper method
  u = User.find(session[:user_id]) # can break out into helper
  # Do API Call
  u.tweet(params["message"])
end

get '/status/:job_id' do
  u = User.find(session[:user_id])
  u.job_is_complete(params[:job_id]).to_json
end

