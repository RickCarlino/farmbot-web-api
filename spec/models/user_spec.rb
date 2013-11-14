require 'spec_helper'

describe User do
  let(:user){FactoryGirl.create(:user, email: 'test@test.com', password: 'password123')}
  #TODO: Write rspec tests for expected values of User attributes.
  it ('has an email'){user.email.should eq('test@test.com')}

  it('has a token'){user.ensure_authentication_token.should be}

  it('has permissions'){user.permissions.should be_an(Array)}

  it 'adds permissions' do
    user.add_permission!('fake_controller#index')
    user.permit?('fake_controller', 'index').should be_true
  end

  it 'removes permissions' do
    permission = user.permissions.first
    user.remove_permission!(permission)
    controller = permission.split('#').first
    action     = permission.split('#').last
    user.permit?(controller, action).should be_false
  end

  it 'returns false for non-permitted paths' do
    user.permit?('fake', 'path').should be_false
  end

  it 'returns true for permitted paths' do
    controller_name = User.default_permissions.first.split('#')[0] #EX: 'api/v1/users'
    action_name     = User.default_permissions.first.split('#')[1] #EX: 'index', 'show', etc...
    user.permit?(controller_name, action_name).should be_true
  end
end
