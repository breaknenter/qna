FactoryBot.define do
  factory :oauth_application, class: 'Doorkeeper::Application' do
    name         { 'TestApp' }
    uid          { 'a0fc5f7d59' }
    secret       { 'd9c2df8e4d' }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
  end
end
