require 'spec_helper'

describe 'Api::V1::Users' do
  let(:user1){ FactoryGirl.create(:user, email: 'test@test.com', password: 'password123') }
  describe 'POST api/v1/tokens' do
    it 'gets a token' do
      post api_v1_tokens_path, {email: user1.email, password: user1.password}
      return_value = JSON.parse(response.body)
      user1.reload
      return_value["token"].should eq(user1.authentication_token)
      response.status.should eq(201)
    end
  end

  describe 'DELETE api/v1/tokens' do
    it 'destroys a token' do
      pending
      delete api_v1_tokens_path
      after = User.count
      response.status.should eq(204)
      before.should be > after
    end
  end
end