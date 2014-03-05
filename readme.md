#Tweet Now! 2: Multi-User
##DBC Challenge 375

#DBC Challenge 313
##Tweet Now! 1: Single User

Tweet as yourself using this telenovela-themed twitter app. Excellente.

Includes local `jQuery` and `jQuery UI` library.

After cloning to local store:
Decrypt / decompress `credentials.tc` into `/config`

Run these commands in terminal to setup:

`bundle update`
`shotgun`

Goal: learn about OAuth v1.

* Twitter OAuth docs: https://dev.twitter.com/docs/auth/oauth
* OAuth v1: http://oauth.net/core/1.0a/
* Twitter gem sample usage: https://github.com/sferik/twitter/tree/master/examples

Notes:
Callback URL specified on Twitter Developer Account will be overwritten by the one inside the request token.
Credentials are read from `credentials.yaml` file into environment variables, then it is used to instantiate the CLIENT.

<hr>

<div class='tab-pane active' id='objectives'>
<p>Building on <a href="/challenges/313">Tweet Now! 1: Single User</a>, let&#39;s add support for logging in with Twitter.  This will be our first application that uses OAuth for authentication.</p>

<p>Twitter uses <a href="http://oauth.net/core/1.0a/">OAuth version 1</a> for API authorization. OAuth (and particularly, OAuth version 1) is hard. As such, we&#39;re going to provide a <a href="http://cl.ly/0T1b461H2C2W">skeleton</a> for you that handles the nasty OAuth bits. Later, if you are feeling adventurous, you can try to code-up your own OAuth conversation.</p>

<h2 id="toc_0">Objectives</h2>

<p>Create an application that allows a user to sign in via Oauth from Twitter and then send a tweet. </p>

<h3 id="toc_1">Download the Application Skeleton</h3>

<p>Here&#39;s the <a href="http://cl.ly/0T1b461H2C2W">application skeleton</a> that you should use that has already implemented the nasty OAuth bits. Unless you&#39;re feeling incredibly ambitious, you should use it as a starting point for your multi-user Tweet Now! app.  </p>

<p><strong>BEFORE</strong> you start, spend time reading the <a href="https://dev.twitter.com/docs/auth/oauth">Twitter OAuth Documentation</a> and familiarize yourself with the basics of OAuth version 1.  See if you can relate what you learn to the image below.</p>

<h3 id="toc_2">Configuring Your Environment</h3>

<p>Your Twitter &quot;consumer key&quot; and &quot;consumer secret&quot; answer the question, &quot;What application is doing the acting?&quot;</p>

<p>The application skeleton we&#39;ve provided expects you to have <code>TWITTER_KEY</code> and <code>TWITTER_SECRET</code> environment variables defined for your running server. This is so that we can deploy things securely to Heroku later.</p>

<p>You can set these keys in your &#39;yaml&#39; file that will not be uploaded to Heroku or Github.  See <a href="https://gist.github.com/dbc-challenges/c513a933644ed9ba2bc8">this post</a> for more details</p>

<p>Or, for a quick start you can simply <code>export</code> these environment variables before we run <code>shotgun</code> (these will only be available for the current session):</p>
<div class="highlight"><pre><span class="nv">$ </span><span class="nb">export </span><span class="nv">TWITTER_KEY</span><span class="o">=</span>&lt;your_twitter_consumer_key&gt;
<span class="nv">$ </span><span class="nb">export </span><span class="nv">TWITTER_SECRET</span><span class="o">=</span>&lt;your_twitter_consumer_secret&gt;
<span class="nv">$ </span>shotgun
</pre></div>
<p>Since you are using OAuth, you will also need to set a <code>callback function</code> which is the route the application wil be directed to after the user is authenticated.  When you are using localhost, this callback function is actually set in the request token (see the helper method in your skeleton), BUT you still need to set something in the callback field when registering your application with Twitter.  As you can read in <a href="https://dev.twitter.com/discussions/5749">this post</a> you can actually set this to any valid url and it will be overwritten by the attribute of your request token. </p>

<h3 id="toc_3">Getting It Running Without Code Changes</h3>

<p>Unlike your previous Twitter applications, the &quot;access token&quot; and &quot;access token secret&quot; will have to change <em>depending on what user is currently authenticated</em>.  This key pair answers the question, &quot;On whose behalf is this application acting?&quot;</p>

<p>Twitter needs to answer both of these questions to make sure that the application is valid and that the application can only do what it has permission to do on behalf of an authenticated user.  </p>

<p>The core OAuth flow goes like this:</p>

<ol>
<li>Application generates URL to &quot;Sign In with Twitter&quot;.</li>
<li>Application renders page with &quot;Sign In with Twitter&quot; link</li>
<li>User clicks &quot;Sign In with Twitter&quot;</li>
<li>User is redirected to Twitter and authorizes the application</li>
<li>User is redirected back to the application&#39;s callback URL</li>
<li>Application verifies the redirection from Twitter is valid</li>
<li>If valid, Application takes appropriate action</li>
</ol>

<p>Assuming you&#39;ve configured things properly, the skeleton app should just run out of the box. However, the skeleton app doesn&#39;t do anything related to creating the user, logginer her in, etc. You&#39;ll need to implement that part on your own later. For now, though, just make sure the application skeleton works (which will prove that your environment and Twitter application are configured correctly).</p>

<h3 id="toc_4">Create Users with Access Tokens in Database</h3>

<p>Now you&#39;ll need to implement that last step of the OAuth flow. Specifically, you&#39;ll need to create the new user, set her as &quot;logged in&quot;, store her access token and secret along with her user record, etc. This should happen inside of the <code>/auth</code> route in your <code>controllers/index.rb</code> file:</p>
<div class="highlight"><pre><span class="n">get</span> <span class="s1">&#39;/auth&#39;</span> <span class="k">do</span>
  <span class="c1"># the `request_token` method is defined in `app/helpers/oauth.rb`</span>
  <span class="vi">@access_token</span> <span class="o">=</span> <span class="n">request_token</span><span class="o">.</span><span class="n">get_access_token</span><span class="p">(</span><span class="ss">:oauth_verifier</span> <span class="o">=&gt;</span> <span class="n">params</span><span class="o">[</span><span class="ss">:oauth_verifier</span><span class="o">]</span><span class="p">)</span>
  <span class="c1"># our request token is only valid until we use it to get an access token, so let&#39;s delete it from our session</span>
  <span class="n">session</span><span class="o">.</span><span class="n">delete</span><span class="p">(</span><span class="ss">:request_token</span><span class="p">)</span>

  <span class="c1"># at this point in the code is where you&#39;ll need to create your user account and store the access token</span>

  <span class="n">erb</span> <span class="ss">:index</span>
<span class="k">end</span>
</pre></div>
<p>We&#39;ll want a <code>User</code> model, however the user won&#39;t have a password.  Instead, the user will be authenticated via OAuth.  With OAuth there&#39;s not necessarily a distinction between signing up and logging in &mdash; the first time a user authenticates via Twitter we can create the <code>User</code> object. Instead of a password, you&#39;ll want to have columns to store her &quot;access token&quot; and &quot;access token secret&quot;.</p>

<h3 id="toc_5">Tweet on behalf of your user</h3>

<p>Now that you have an authenticated user who has authorized you to use Twitter on their behalf, revisit your &quot;Tweet Now!&quot; app and send some tweets for this user. </p>

<h3 id="toc_6">How the OAuth (v1) Conversation Works</h3>

<p><img src="https://docs.google.com/drawings/d/1E0SMvb5_vL6aqLD3sngHzC1Kn_K_N_P11ooauSf2FKQ/pub?w=960&h=720"></p>

<h3 id="toc_7">Deploying Securely to Heroku</h3>

<p><strong>STOP</strong> - Go find your laptop and use it to deploy to Heroku - please (no really please) do not reset the SSH keys on DBC machines. </p>

<p>We don&#39;t want our confidential information (like application keys and secrets) to be stored in git, especially if we&#39;re going to push this to a public repository. If we <em>were</em> to store them in a public repository, anyone would be able to pretend to be our application. <strong>NOT good.</strong></p>

<p>Configuring the <code>TWITTER_KEY</code> and <code>TWITTER_SECRET</code> environment variables on our local machine was easy. <a href="https://devcenter.heroku.com/articles/config-vars">On Heroku, it&#39;s slighly more complicated</a>:</p>
<div class="highlight"><pre><span class="nv">$ </span>heroku config:add <span class="nv">TWITTER_KEY</span><span class="o">=</span>&lt;your_twitter_consumer_key&gt; <span class="nv">TWITTER_SECRET</span><span class="o">=</span>&lt;your_twitter_consumer_secret&gt;
</pre></div>
<p>After that, you should be able to deploy! :)</p>

<p>Get to it.  Create a new Heroku application.  Add Heroku as a git remote.  Run <code>heroku config:add</code> to set up the Twitter key and secret.  Push to Heroku.</p>

</div>
