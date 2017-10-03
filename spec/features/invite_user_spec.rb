require 'rails_helper'

describe 'Invite user', feature: true do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:email) { 'random@test.com' }

  context 'unauthenticated user' do
    before do
      visit new_user_invitation_path
    end

    it 'asks them to sign in' do
      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end
  end

  context 'non admin user' do
    before do
      visit new_user_session_path
      fill_in('user_email', with: user.email)
      fill_in('user_password', with: user.password)
      click_button('Log in')
      visit new_user_invitation_path
    end

    it 'tells them they cannot view the page' do
      expect(page).to have_content('Admins only!')
    end
  end

  context 'authenticated admin' do
    before do
      visit new_user_session_path
      fill_in('user_email', with: admin.email)
      fill_in('user_password', with: admin.password)
      click_button('Log in')
      click_link('Invite User')
    end

    it 'displays the page' do
      expect(page).to have_content('Invite User')
      expect(page).to have_css('#user_email')
      expect(page).to have_selector("input[type=submit][value='Send an invitation']")
    end

    it 'creates a user' do
      user_count = User.count
      fill_in('user_email', with: email)
      fill_in('user_name', with: 'random')
      click_button('Send an invitation')
      expect(page).to have_content("An invitation email has been sent to #{email}")
      expect(User.count).to eql(user_count + 1)
    end
  end
end
