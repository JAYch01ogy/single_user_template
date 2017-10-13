require 'rails_helper'

describe 'Log in', feature: true do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  context 'unauthenticated user visiting log in page' do
    before do
      visit new_user_session_path
    end

    it 'displays the page' do
      expect(page).to have_content('Log in')
      expect(page).to have_css('#user_email')
      expect(page).to have_css('#user_password')
      expect(page).to have_selector("input[type=submit][value='Log in']")
    end
  end

  context 'non admin user logging in' do
    before do
      log_in(user)
    end

    it 'displays logged in non admin user home page' do
      expect(page).to have_content('Signed in successfully.')
      expect(page).to have_content('Home')
      expect(page).to have_content('Logout')
      expect(page).to have_content('Profile')
      expect(page).not_to have_content('Login')
      expect(page).not_to have_content('Invite User')
      expect(page).not_to have_content('Users')
    end

    it 'allows logging out' do
      click_link('Logout')
      expect(page).to have_content('Signed out successfully.')
      expect(page).not_to have_content('Logout')
      expect(page).not_to have_content('Profile')
      expect(page).to have_content('Login')
    end
  end

  context 'admin user logging in' do
    before do
      log_in(admin)
    end

    it 'displays logged in admin user home page' do
      expect(page).to have_content('Signed in successfully.')
      expect(page).to have_content('Home')
      expect(page).to have_content('Profile')
      expect(page).to have_content('Invite User')
      expect(page).to have_content('Users')
      expect(page).to have_content('Logout')
      expect(page).not_to have_content('Login')
    end

    it 'allows logging out' do
      click_link('Logout')
      expect(page).to have_content('Signed out successfully.')
      expect(page).not_to have_content('Profile')
      expect(page).not_to have_content('Logout')
      expect(page).not_to have_content('Invite User')
      expect(page).not_to have_content('Users')
      expect(page).to have_content('Login')
    end
  end
end
