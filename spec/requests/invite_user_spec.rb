require 'rails_helper'

describe 'Invite user', type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:random_email) { Faker::Internet.email }
  let(:random_name) { Faker::Name.first_name }

  context 'GET #new' do
    it 'redirects unauthenticated to log in' do
      get new_user_invitation_path
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:new_user_session)
      follow_redirect!
      expect(response).to render_template(:new)
    end

    it 'redirects non admin user to home' do
      request_log_in(user)
      get new_user_invitation_path
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:root)
      follow_redirect!
      expect(response).to render_template(:home)
    end

    it 'renders new_user_invitation_path for admin' do
      request_log_in(admin)
      get new_user_invitation_path
      expect(response.status).to eql(200)
      expect(response).to render_template(:new)
    end
  end

  context 'POST #create' do
    it 'redirects unauthenticated user invite to log in' do
      post user_invitation_path, params: { user: { email: random_email, name: random_name } }
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:new_user_session)
      follow_redirect!
      expect(response).to render_template(:new)
      expect(User.count).to eql(0)
    end

    it 'redirects non admin user to home' do
      request_log_in(user)
      post user_invitation_path, params: { user: { email: random_email, name: random_name } }
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:root)
      follow_redirect!
      expect(response).to render_template(:home)
      expect(User.count).to eql(1)
    end

    it 'redirects admin user to home and creates a user' do
      request_log_in(admin)
      post user_invitation_path, params: { user: { email: random_email, name: random_name } }
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:root)
      follow_redirect!
      expect(response).to render_template(:home)
      expect(User.count).to eql(2)
    end

    it 'does not allow creation of admin users' do
      request_log_in(admin)
      post user_invitation_path, params: { user: { email: random_email, name: random_name, admin: true } }
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:root)
      follow_redirect!
      expect(response).to render_template(:home)
      expect(User.count).to eql(2)
      expect(User.last.admin).to be(false)
    end
  end
end
