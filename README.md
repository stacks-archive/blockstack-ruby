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
 
Convenience method `git_bitcoin_address` can be used for retrieving Bitcoin addresses.  If you give it a Bitcoin address it will return the same Bitcoin address; if you give it an Openname it will return the Openname user's Bitcoin address. Useful for allowing end users to either directly specify a Bitcoin address or provide a Openname in the same input field. 

```
 require "openname"
 
 larrys_bitcoin_address = Openname.get_bitcoin_address("larry")
 
 an_address = "143xFrxppUD9oQE7mGvQFe23h814YorMBs
 an_address == Openname.get_bitcoin_address("143xFrxppUD9oQE7mGvQFe23h814YorMBs") # evaluates to true

 ```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
