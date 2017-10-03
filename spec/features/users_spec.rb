require 'rails_helper'

describe 'Users page', feature: true do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:email) { 'random@test.com' }

  context 'unauthenticated user' do
    before do
      visit users_path
    end

    it 'displays admin only message' do
      expect(page).to have_content('Admins only!')
    end
  end

  context 'non admin user' do
    before do
      visit new_user_session_path
      fill_in('user_email', with: user.email)
      fill_in('user_password', with: user.password)
      click_button('Log in')
      visit users_path
    end

    it 'displays admin only message' do
      expect(page).to have_content('Admins only!')
    end
  end

  context 'authenticated admin' do
    before do
      create_list(:user, 3)
      visit new_user_session_path
      fill_in('user_email', with: admin.email)
      fill_in('user_password', with: admin.password)
      click_button('Log in')
      click_link('Users')
    end

    it 'displays the page' do
      User.all.each do |user|
        expect(page).to have_content(user.email)
        expect(page).to have_content(user.name)
      end
    end

    it 'displays selected user' do
      click_link(User.first.email)
      expect(page).to have_content(User.first.email)
    end
  end
end
