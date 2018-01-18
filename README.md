# Blockstack Ruby

The Blockstack ruby library for identity and authentication

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'blockstack'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install blockstack

## Usage

The Blockstack Ruby gem can be used to enable authentication with Blockstack on ruby apps
where authentication needs to occur on the server.

Authentication requests are generated with the [blockstack-js](https://github.com/blockstack/blockstack.js) JavaScript library in the user's web browser.

Authentication responses from the user's Blockstack Portal will be sent to a callback URL
that you provide and are verified using this library on your server.

For an example of this process and library in action, see
the [OmniAuth Blockstack strategy](https://github.com/blockstack/omniauth-blockstack).

### To verify an auth response

```ruby
require 'blockstack'

begin
  auth_response = request.params['authResponse']

  decoded_auth_response = Blockstack.verify_auth_response auth_response

  # login succeeded
  users_unique_id = decoded_auth_response['iss']
  verified_username = decoded_auth_response['username'] # nil if not provided
  profile = decoded_auth_response['profile']
rescue Blockstack::InvalidAuthResponse => error
  # login failed
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/blockstack/blockstack-ruby.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
