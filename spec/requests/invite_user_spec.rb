require 'rails_helper'

describe 'Invite user', type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  context 'GET #new' do
    it 'redirects unauthenticated to log in' do
      get new_user_invitation_path
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:new_user_session)
      follow_redirect!
      expect(response).to render_template(:new)
    end

    it 'redirects non admin user to home' do
      post user_session_path, params: { user: { email: user.email, password: user.password } }
      expect(response).to redirect_to(:root)
      follow_redirect!
      get new_user_invitation_path
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:root)
      follow_redirect!
      expect(response).to render_template(:home)
    end

    it 'renders new_user_invitation_path for admin' do
      post user_session_path, params: { user: { email: admin.email, password: admin.password } }
      expect(response).to redirect_to(:root)
      follow_redirect!
      get new_user_invitation_path
      expect(response.status).to eql(200)
      expect(response).to render_template(:new)
    end
  end

  context 'POST #create' do
    it 'redirects unauthenticated user invite to log in' do
      post '/users/invitation', params: { user: { email: 'random@test.com' } }
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:new_user_session)
      follow_redirect!
      expect(response).to render_template(:new)
      expect(User.count).to eql(0)
    end

    it 'redirects non admin user to home' do
      post user_session_path, params: { user: { email: user.email, password: user.password } }
      expect(response).to redirect_to(:root)
      follow_redirect!
      post '/users/invitation', params: { user: { email: 'random@test.com' } }
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:root)
      follow_redirect!
      expect(response).to render_template(:home)
      expect(User.count).to eql(1)
    end

    it 'redirects admin user to home and creates a user' do
      post user_session_path, params: { user: { email: admin.email, password: admin.password } }
      expect(response).to redirect_to(:root)
      follow_redirect!
      post '/users/invitation', params: { user: { email: 'random@test.com' } }
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:root)
      follow_redirect!
      expect(response).to render_template(:home)
      expect(User.count).to eql(2)
    end
  end
end
