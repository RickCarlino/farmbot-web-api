require 'spec_helper'

describe 'Api::V1::Users' do
  let(:user1){ FactoryGirl.create(:user, email: 'test@test.com', password: 'password123') }
  describe 'GET /api/v1/users' do
    it 'returns empty array when user count is 0' do
      get api_v1_users_path
      response.body.should eq('[]')
    end

    it 'returns a document representing all users' do
      user1 = FactoryGirl.create(:user, email: 'test@test.com', password: 'password123')
      get api_v1_users_path
      return_value = JSON.parse(response.body)
      return_value[0]["email"].should eq(user1.email)
      return_value[0]["id"].should eq(user1._id.to_s)
      return_value[0]["sign_in_count"].should eq(user1.sign_in_count)
      return_value[0]["current_sign_in_at"].should eq(user1.current_sign_in_at)
      return_value[0]["last_sign_in_at"].should eq(user1.last_sign_in_at)
      return_value[0]["current_sign_in_ip"].should eq(user1.current_sign_in_ip)
      return_value[0]["last_sign_in_ip"].should eq(user1.last_sign_in_ip)
      response.status.should eq(200)
    end

    it 'stops unauthorized users from viewing records'

    it 'paginates user record results'
  end

  describe 'GET /api/v1/users/:id' do
    it 'returns a JSON ' do
      get api_v1_user_path(user1)
      return_value = JSON.parse(response.body)
      return_value["email"].should eq(user1.email)
      return_value["id"].should eq(user1._id.to_s)
      return_value["sign_in_count"].should eq(user1.sign_in_count)
      return_value["current_sign_in_at"].should eq(user1.current_sign_in_at)
      return_value["last_sign_in_at"].should eq(user1.last_sign_in_at)
      return_value["current_sign_in_ip"].should eq(user1.current_sign_in_ip)
      return_value["last_sign_in_ip"].should eq(user1.last_sign_in_ip)
      response.status.should eq(200)
    end

    it 'returns 404 for missing records' do
      get api_v1_user_path('nope')
      response.status.should eq(404)
    end
  end

  describe 'PUT /api/v1/users/:id' do
    it 'updates a User document' do
      put api_v1_user_path user1, {id: user1.id.to_s, email: 'changed@changed.com', password: 'password123'}
      response.status.should eq(204)
    end

    it 'returns unprocessable entity for malformed requests' do
      post api_v1_users_path, {not: 'a', valid: 'request'}
      return_value = JSON.parse(response.body)
      response.status.should eq(422)
    end

    it 'gives a 420 status for unauthorized requests'
  end

  describe 'POST /api/v1/users' do
    it 'creates a user' do
      post api_v1_users_path, {email: 'rick@rick.io', password: 'soopersecret'}
      return_value = JSON.parse(response.body)
      return_value["email"].should eq('rick@rick.io')
      return_value["id"].should be
      response.status.should eq(201)
    end

    it 'returns unprocessable entity for malformed requests' do
      post api_v1_users_path, {not: 'a', valid: 'request'}
      return_value = JSON.parse(response.body)
      response.status.should eq(422)
    end
  end

  describe 'DELETE /api/v1/users/:id' do
    it 'deletes a user' do
      #OPTIMIZE: This test might not be thread safe. Might be an issue if we switch to parellel testing.
      user1 #Because it gets lazy loaded, we need to load it now to get a count.
      before = User.count
      delete api_v1_user_path(user1)
      after = User.count
      response.status.should eq(204)
      before.should be > after
    end
  end
end
