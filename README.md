# Clef + Rails
![license:mit](https://img.shields.io/badge/license-mit-blue.svg)

## Getting started
Clef is secure two-factor auth without passwords. With the wave of their phone, users can log in to your site — it's like :sparkles: magic :sparkles:! 

Get started in three easy steps:
* Download the [iOS](https://itunes.apple.com/us/app/clef/id558706348) or [Android](https://play.google.com/store/apps/details?id=io.clef&hl=en) app on your phone 
* Sign up for a Clef developer account at [https://www.getclef.com/developer](https://www.getclef.com/developer) and create an application. That's where you'll get your API credentials (`app_id` and `app_secret`) and manage settings for your Clef integration.
* Follow the directions below to integrate Clef into your site's log in flow. 

## Usage
We'll walk you through the full Clef integration with Ruby and Rails below. You can also run this sample app [locally](#running-this-sample-app).

### Adding the Clef button

The Clef button is the entry point into the Clef experience. Adding it to your site is as easy as dropping a `script` tag wherever you want the button to show up. 

Set the `data-redirect-url` to the URL in your app where you will complete the OAuth handshake. You'll also want to set `data-state` to an unguessable random string. <br>

```javascript
<script type='text/javascript' 
    class='clef-button' 
    src='https://clef.io/v3/clef.js' 
    data-app-id='YOUR_APP_ID' 
    data-redirect-url='http://localhost:3000/auth/clef/callback' 
    data-state='<%= state_parameter %>'>
</script>
```
*See the code in [action](/app/views/users/new.html.erb#L3) or read more [here](http://docs.getclef.com/v1.0/docs/adding-the-clef-button).*<br>

### Completing the OAuth handshake
Once you've set up the Clef button, you need to be able to handle the OAuth handshake. This is what lets you retrieve information about a user after they authenticate with Clef. The easiest way to do this is to use OmniAuth, which you should add to your Gemfile:

`$ gem 'omniauth-clef'`

Configure it with your `app_id` and `app_secret` in a <code><a href="/config/initializers/omniauth.rb#L1-L3" target="_blank">config/initializers/omniauth.rb</a></code> file.

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :clef, 'YOUR_APP_ID', 'YOUR_APP_SECRET'
end
```

Clef requires verifying the `state` parameter in the OAuth handhsake. OmniAuth handles verification for you, but you'll need to <code><a href="/app/controllers/users_controller.rb#L101-L103" target="_blank">generate</a></code> the parameter in your own helper method in `users_controller.rb` and pass it to the Clef button.

When you handle the OmniAuth callback, you can get or create a user from your database and set them in the session. 

```ruby
# POST /users
# POST /users.json
def create
  @user = User.find_or_create_from_auth_hash(request.env['omniauth.auth'])

  respond_to do |format|
    if @user.save
      if @user.persisted?
        notice = "User was logged in."
      else
        notice = "User was created."
      end
      session[:user] = @user.id
      format.html { redirect_to @user, notice: notice }
      format.json { render json: @user, status: :created, location: @user }
    else
      format.html { render action: "new" }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end
end
```
*See the code in [action](/app/controllers/users_controller.rb#L44-L64) or read more [here](http://docs.getclef.com/v1.0/docs/authenticating-users).*<br>

## Running this sample app 
To run this sample app, clone the repo:

```
$ git clone https://github.com/clef/sample-rails.git
```

Then install the dependencies, set up a local database and run on localhost.
```
$ bundle install
$ rails generate scaffold User email:string clef_id:integer
$ rake db:migrate
$ rails s 
```

## Documentation
You can find our most up-to-date documentation at [http://docs.getclef.com](http://docs.getclef.com/). It covers additional topics like customizing the Clef button and testing your integration.

## Support
Have a question or just want to chat? Send an email to [support@getclef.com](mailto: support@getclef.com) or join our community Slack channel :point_right: [http://community.getclef.com](http://community.getclef.com).

We're always around, but we do an official Q&A every Friday from 10am to noon PST :) — would love to see you there! 

## About 
Clef is an Oakland-based company building a better way to log in online. We power logins on more than 80,000 websites and are building a beautiful experience and inclusive culture. Read more about our [values](https://getclef.com/values), and if you like what you see, come [work with us](https://getclef.com/jobs)!

