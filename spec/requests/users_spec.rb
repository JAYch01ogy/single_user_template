require 'rails_helper'

describe 'Users', type: :request do
  let!(:user) { create(:user) }
  let!(:user_being_deleted) { create(:user) }
  let!(:admin) { create(:user, :admin) }
  let!(:prior_user_count) { User.count }

  it 'allows admin to delete a user' do
    post user_session_path, params: { user: { email: admin.email, password: admin.password } }
    follow_redirect!
    delete user_path(user_being_deleted.id)
    expect(response.status).to eql(302)
    expect(response).to redirect_to(:users)
    expect(User.count).to eql(prior_user_count - 1)
  end

  it 'prevents admin from deleting an admin user' do
    post user_session_path, params: { user: { email: admin.email, password: admin.password } }
    follow_redirect!
    delete user_path(admin.id)
    expect(response.status).to eql(302)
    expect(response).to redirect_to(:users)
    expect(User.count).to eql(prior_user_count)
  end

  it 'prevents non admin user from deleting themselves' do
    post user_session_path, params: { user: { email: user.email, password: user.password } }
    follow_redirect!
    delete user_path(user.id)
    expect(response.status).to eql(302)
    expect(response).to redirect_to(:root)
    expect(User.count).to eql(prior_user_count)
  end

  it 'prevents non admin user from deleting a user' do
    post user_session_path, params: { user: { email: user.email, password: user.password } }
    follow_redirect!
    delete user_path(user_being_deleted.id)
    expect(response.status).to eql(302)
    expect(response).to redirect_to(:root)
    expect(User.count).to eql(prior_user_count)
  end

  it 'prevents non admin user from deleting an admin user' do
    post user_session_path, params: { user: { email: user.email, password: user.password } }
    follow_redirect!
    delete user_path(admin.id)
    expect(response.status).to eql(302)
    expect(response).to redirect_to(:root)
    expect(User.count).to eql(prior_user_count)
  end

  it 'prevents unathenticated users from deleting a user' do
    delete user_path(user_being_deleted.id)
    expect(response.status).to eql(302)
    expect(response).to redirect_to(:root)
    expect(User.count).to eql(prior_user_count)
  end

  it 'prevents unathenticated users from deleting an admin user' do
    delete user_path(admin.id)
    expect(response.status).to eql(302)
    expect(response).to redirect_to(:root)
    expect(User.count).to eql(prior_user_count)
  end
end
