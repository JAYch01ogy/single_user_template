require 'rails_helper'

describe 'Edit user', type: :request do
  let!(:user) { create(:user) }
  let!(:admin) { create(:user, :admin) }
  let(:random_email) { Faker::Internet.email }
  let(:random_name) { Faker::Name.first_name }

  context 'GET #edit' do
    it 'redirects unauthenticated to root_path' do
      get edit_user_path(user.id)
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:root)
      follow_redirect!
      expect(response).to render_template(:home)
    end

    it 'renders user edit page if non admin user attempts viewing themselves' do
      request_log_in(user)
      get edit_user_path(user.id)
      expect(response.status).to eql(200)
      expect(response).to render_template(:edit)
    end

    it 'redirects to root if non admin user attempts viewing someone else' do
      request_log_in(user)
      get edit_user_path(admin.id)
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:root)
      follow_redirect!
      expect(response).to render_template(:home)
    end

    it 'renders admin user edit page for admin' do
      request_log_in(admin)
      get edit_user_path(admin.id)
      expect(response.status).to eql(200)
      expect(response).to render_template(:edit)
    end

    it 'renders user edit page for admin' do
      request_log_in(admin)
      get edit_user_path(user.id)
      expect(response.status).to eql(200)
      expect(response).to render_template(:edit)
    end
  end

  context 'POST #update' do
    it 'redirects unauthenticated to root_path' do
      patch user_path(user.id), params: { user: { email: random_email, name: random_name } }
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:root)
      follow_redirect!
      expect(response).to render_template(:home)
    end

    it 'redirects to show and updates users attempting to update their own information' do
      request_log_in(user)
      patch user_path(user.id), params: { user: { email: random_email, name: random_name } }
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:user)
      follow_redirect!
      expect(response).to render_template(:show)
      expect(user.reload.email).to eql(random_email)
      expect(user.reload.name).to eql(random_name)
    end

    it 'redirects to root and does not updates users attempting to update another user\'s information' do
      request_log_in(user)
      patch user_path(admin.id), params: { user: { email: random_email, name: random_name } }
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:root)
      follow_redirect!
      expect(response).to render_template(:home)
      expect(admin.reload.email).not_to eql(random_email)
      expect(admin.reload.name).not_to eql(random_name)
    end

    it 'redirects to show and updates admin users attempting to update their own information' do
      request_log_in(admin)
      patch user_path(admin.id), params: { user: { email: random_email, name: random_name } }
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:user)
      follow_redirect!
      expect(response).to render_template(:show)
      expect(admin.reload.email).to eql(random_email)
      expect(admin.reload.name).to eql(random_name)
    end

    it 'redirects to show and updates a user when admin is attempting to update a user\'s information' do
      request_log_in(admin)
      patch user_path(user.id), params: { user: { email: random_email, name: random_name } }
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:user)
      follow_redirect!
      expect(response).to render_template(:show)
      expect(user.reload.email).to eql(random_email)
      expect(user.reload.name).to eql(random_name)
    end

    it 'does not allow updating a user to admin' do
      request_log_in(admin)
      patch user_path(user.id), params: { user: { email: random_email, name: random_name, admin: true } }
      expect(response.status).to eql(302)
      expect(response).to redirect_to(:user)
      follow_redirect!
      expect(response).to render_template(:show)
      expect(user.reload.email).to eql(random_email)
      expect(user.reload.name).to eql(random_name)
      expect(user.reload.admin).to be(false)
    end
  end
end
