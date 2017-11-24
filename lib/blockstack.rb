require 'blockstack/version'
require 'blockstack/user'
require 'bitcoin'
require 'faraday'
require 'jwtb'

module Blockstack
  class InvalidAuthResponse < StandardError; end

  USER_AGENT = "blockstack-ruby #{VERSION}"
  ALGORITHM = 'ES256K'
  REQUIRED_CLAIMS = %w(iss iat jti exp username profile public_keys)

  DEFAULT_LEEWAY = 30 # seconds
  DEFAULT_VALID_WITHIN = 30 # seconds
  DEFAULT_API = 'http://localhost:6270'

  def self.api=(api)
    @api = api || DEFAULT_API
  end

  def self.api
    @api
  end

  def self.leeway=(leeway)
    @leeway = leeway || DEFAULT_LEEWAY
  end

  def self.leeway
    @leeway
  end

  def self.valid_within=(valid_within)
    @valid_within = valid_within || DEFAULT_VALID_WITHIN
  end

  def self.valid_within
    @valid_within
  end

  def self.verify_auth_response(auth_token)
    # decode & verify token without checking signature so we can extract
    # public keys
    public_key = nil
    verify = false
    decoded_tokens = JWTB.decode auth_token, public_key, verify, algorithm: ALGORITHM
    decoded_token = decoded_tokens[0]

    REQUIRED_CLAIMS.each do |field|
      raise InvalidAuthResponse.new("Missing required '#{field}' claim.") unless decoded_token.key?(field.to_s)
    end
    raise InvalidAuthResponse.new("Missing required 'iat' claim.") unless decoded_token['iat']
    raise InvalidAuthResponse.new("'iat' timestamp claim is skewed too far from present.") if (Time.now.to_i - decoded_token['iat']).abs > self.valid_within

    public_keys = decoded_token['public_keys']

    raise InvalidAuthResponse.new('Invalid public_keys array: only 1 key is supported') unless public_keys.length == 1

    compressed_hex_public_key = public_keys[0]
    bignum = OpenSSL::BN.new(compressed_hex_public_key, 16)
    group = OpenSSL::PKey::EC::Group.new 'secp256k1'
    public_key = OpenSSL::PKey::EC::Point.new(group, bignum)
    ecdsa_key = OpenSSL::PKey::EC.new 'secp256k1'
    ecdsa_key.public_key = public_key
    verify = true

    # decode & verify signature
    decoded_tokens = JWTB.decode auth_token, ecdsa_key, verify, algorithm: ALGORITHM, exp_leeway: self.leeway
    decoded_token = decoded_tokens[0]

    raise InvalidAuthResponse.new("Public keys don't match issuer address") unless self.public_keys_match_issuer?(decoded_token)

    raise InvalidAuthResponse.new("Public keys don't match owner of claimed username") unless self.public_keys_match_username?(decoded_token)

    return decoded_token
  rescue JWTB::VerificationError
    raise InvalidAuthResponse.new('Signature on JWT is invalid')
  rescue JWTB::DecodeError
    raise InvalidAuthResponse.new('Unable to decode JWT')
  rescue RuntimeError => error
    raise InvalidAuthResponse.new(error.message)
  end

  def self.get_did_type(decentralized_id)
    did_parts = decentralized_id.split(':')
    raise 'Decentralized IDs must have 3 parts' if did_parts.length != 3
    raise 'Decentralized IDs must start with "did"' if did_parts[0].downcase != 'did'
    did_parts[1].downcase
  end

  def self.get_address_from_did(decentralized_id)
    did_type = get_did_type(decentralized_id)
    return nil if did_type != 'btc-addr'
    decentralized_id.split(':')[2]
  end

  protected

  def self.public_keys_match_issuer?(decoded_token)
    public_keys = decoded_token['public_keys']
    address_from_issuer = get_address_from_did(decoded_token['iss'])

    raise 'Multiple public keys are not supported' unless public_keys.count == 1

    address_from_public_keys = Bitcoin::pubkey_to_address public_keys.first

    address_from_issuer == address_from_public_keys
  end

  def self.public_keys_match_username?(decoded_token)
    username = decoded_token['username']
    return true if username.nil?

    response = Faraday.get "#{self.api}/v1/names/#{username}"
    json = JSON.parse response.body

    raise "Issuer claimed username that doesn't exist" if response.status == 404
    raise "Unable to verify issuer's claimed username" if response.status != 200

    name_owning_address = json['address']
    address_from_issuer = get_address_from_did decoded_token['iss']
    name_owning_address == address_from_issuer
  end

  def self.faraday
    connection = Faraday.new
    connection.headers[:user_agent] = USER_AGENT
    connection
  end

  private

  @leeway = DEFAULT_LEEWAY
  @valid_within = DEFAULT_VALID_WITHIN
  @api = DEFAULT_API
end
