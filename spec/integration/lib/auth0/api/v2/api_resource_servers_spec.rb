require 'spec_helper'
describe Auth0::Api::V2::ResourceServers do
  attr_reader :client, :enabled_rule, :disabled_rule

  before(:all) do
    @client = Auth0Client.new(v2_creds)
    name = Faker::Lorem.word
    identifier = Faker::Lorem.word
    @resource_server = client.create_resource_server(name, identifier)
  end

  after(:all) do
    client.delete_resource_server(resource_server['id'])
  end

  describe '.resource_server' do
    it do
      expect(client.resource_server(resource_server['id'])).to(
        include('name' => resource_server['name'], 'identifier' => resource_server['identifier'], 'id' => resource_server['id']))
    end
  end

  describe '.create_resource_server' do
    let(:name) { Faker::Lorem.word }
    let(:identifier) { Faker::Lorem.word }
    let(:signing_alg) { "HS256" }
    let(:signing_secret) { Faker::Lorem.word }
    let(:token_lifetime) { rand(1000..3000)  }
    let(:scope) { ["Test Scope"] }
    let!(:resource_server) do
      client.create_resource_server(name, identifier, 'signing_alg' => signing_alg,
                                                      'signing_secret' => signing_secret,
                                                      'token_lifetime' => token_lifetime,
                                                      'scope' => scope) }
    end

    it do
      expect(resource_server).to include('name' => name, 'identifier' => identifier, 'signing_alg' => signing_alg,
                                                                                     'signing_secret' => signing_secret,
                                                                                     'token_lifetime' => token_lifetime,
                                                                                     'scope' => scope)
    end
    it { expect { client.delete_resource_server(resource_server['id']) }.to_not raise_error }
  end

  describe '.delete_resource_server' do
    it { expect { client.delete_resource_server(resource_server['id']) }.to_not raise_error }
    it { expect { client.delete_delete_resource_server '' }.to raise_error(Auth0::InvalidParameter) }
  end

end
