require 'blockstack'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

Dir['./spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
end
