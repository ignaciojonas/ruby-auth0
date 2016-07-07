require 'spec_helper'
describe Auth0::Api::AuthenticationEndpoints do
  attr_reader :client, :impersonate_user, :impersonator_user, :global_client, :password

  before(:all) do
    client = Auth0Client.new(v2_creds)
    impersonate_username = Faker::Internet.user_name
    impersonate_email = "#{entity_suffix}#{Faker::Internet.safe_email(impersonate_username)}"
    @password = Faker::Internet.password
    @impersonate_user = client.create_user(impersonate_username, 'email' => impersonate_email,
                                                                 'password' => password,
                                                                 'email_verified' => true,
                                                                 'connection' =>
                                                                  Auth0::Api::AuthenticationEndpoints::UP_AUTH,
                                                                 'app_metadata' => {})

    impersonator_username = Faker::Internet.user_name
    impersonator_email = "#{entity_suffix}#{Faker::Internet.safe_email(impersonator_username)}"
    @impersonator_user = client.create_user(impersonator_username, 'email' => impersonator_email,
                                                                   'password' => password,
                                                                   'email_verified' => true,
                                                                   'connection' =>
                                                                    Auth0::Api::AuthenticationEndpoints::UP_AUTH,
                                                                   'app_metadata' => {})

     @global_client = Auth0Client.new(v1_global_creds)
  end

  after(:all) do
    client.delete_user(impersonate_user['user_id'])
    client.delete_user(impersonator_user['user_id'])
  end

  describe '.obtain_access_token' do
    let(:acces_token) do
      global_client.obtain_access_token
    end
    it { expect(acces_token).to_not be_nil }
  end

  describe '.login' do
    let(:login) do
      global_client.login(impersonate_user['email'], password)
    end
    it { expect(login).to( include('id_token', 'access_token', 'token_type')) }
  end

  describe '.signup' do
    let(:signup_username) { Faker::Internet.user_name }
    let(:signup_email) { "#{entity_suffix}#{Faker::Internet.safe_email(signup_username)}" }
    let(:signup) do
      global_client.signup(signup_email, password)
    end
    it { expect(signup).to( include('_id', 'email')) }
  end

  describe '.change_password' do
    let(:change_password) do
      global_client.change_password(impersonate_user['user_id'], password)
    end
    it { expect(change_password).to eq '"We\'ve just sent you an email to reset your password."' }
  end

  describe '.start_passwordless_email_flow' do
    let(:start_passwordless_email_flow) do
      global_client.start_passwordless_email_flow(impersonate_user['email'])
    end
    it { expect(start_passwordless_email_flow).to eq '"We\'ve just sent you an email to reset your password."' }
  end

  describe '.start_passwordless_sms_flow' do
    let(:phone_number) { '+123456778' }
    let(:start_passwordless_sms_flow) do
      binding.pry
      global_client.start_passwordless_sms_flow(phone_number)
    end
    it { expect(start_passwordless_sms_flow).to eq '"We\'ve just sent you an email to reset your password."' }
  end

  skip '.impersonation' do
    let(:impersonate_url) do
      global_client.impersonate(impersonate_user['user_id'], ENV['CLIENT_ID'], impersonator_user['user_id'], {})
    end
    it { expect(impersonate_url).to_not be_nil }
  end
end
