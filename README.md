# Openname

A ruby library for the Openname distributed identity & naming system

## Installation

Add this line to your application's Gemfile:

    gem 'openname'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install openname

## Usage

 ```
 require "openname"
 user = Openname.get("larry")
 
 larrys_bitcoin_address = user.bitcoin_address
 larrys_website = user.website
 ```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
