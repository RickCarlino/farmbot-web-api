require 'spec_helper'

describe User do
  let(:user){FactoryGirl.create(:user, email: 'test@test.com', password: 'password123')}
  #TODO: Write rspec tests for expected values of User attributes.
  it 'has an email' do
    user.email.should eq('test@test.com')
  end

  it 'has a token' do
    user.ensure_authentication_token.should be
  end
end
