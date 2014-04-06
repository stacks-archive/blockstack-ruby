# Onename

A ruby library for the OneName distributed identity system

## Installation

Add this line to your application's Gemfile:

    gem 'onename'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install onename

## Usage

 ```
 require "onename"
 user = Onename.get("larry")
 
 larrys_bitcoin_address = user.bitcoin_address
 larrys_website = user.website
 ```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
