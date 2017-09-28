require 'rails_helper'

describe 'Log in', type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  context 'GET #new' do
    it 'renders new_user_session_path' do
      get new_user_session_path
      expect(response.status).to eql(200)
      expect(response).to render_template(:new)
    end
  end

  context 'POST #create' do
    it 'redirects to new_user_session_path when no credentials' do
      post user_session_path, params: {}
      expect(response.status).to eql(200)
      expect(response).to render_template(:new)
      expect(response).not_to redirect_to(:root)
    end

    it 'redirects to new_user_session_path with invalid credentials' do
      post user_session_path, params: { user: { email: admin.email, password: 'jibberish' } }
      expect(response.status).to eql(200)
      expect(response).to render_template(:new)
      expect(response).not_to redirect_to(:root)
    end

    it 'redirects to root_path with valid non admin credentials' do
      post user_session_path, params: { user: { email: user.email, password: user.password } }
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:root)
      follow_redirect!
      expect(response).to render_template(:home)
    end

    it 'redirects to root_path with valid admin credentials' do
      post user_session_path, params: { user: { email: admin.email, password: admin.password } }
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:root)
      follow_redirect!
      expect(response).to render_template(:home)
    end

    it 'redirects non admin user to root' do
      post user_session_path, params: { user: { email: user.email, password: user.password } }
      expect(response).to redirect_to(:root)
      follow_redirect!
      get new_user_session_path
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:root)
      follow_redirect!
      expect(response).to render_template(:home)
    end
  end
end
