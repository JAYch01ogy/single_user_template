require 'rails_helper'

describe 'Devise log in', type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  before do
    get new_user_session_path
  end

  it 'renders new' do
    expect(response).to render_template(:new)
  end

  it 'redirects to new_user_session_path with no credentials' do
    post user_session_path, :params => {}
    expect(response).to render_template(:new)
    expect(response).not_to redirect_to(:root)
  end

  it 'redirects to new_user_session_path with invalid credentials' do
    post user_session_path, :params => { :user => { email: admin.email, password: 'jibberish' } }
    expect(response).to render_template(:new)
    expect(response).not_to redirect_to(:root)
  end

  it 'non admin redirects to root_path with valid credentials' do
    post user_session_path, :params => { :user => { email: user.email, password: user.password } }
    expect(response).to redirect_to(:root)
  end

  it 'admin redirects to root_path with valid credentials' do
    post user_session_path, :params => { :user => { email: admin.email, password: admin.password } }
    expect(response).to redirect_to(:root)
  end
end
