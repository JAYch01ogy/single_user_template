require 'rails_helper'

describe 'Invite user', feature: true do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:random_email) { Faker::Internet.email }
  let(:random_name) { Faker::Name.first_name }

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
      log_in(user)
      visit new_user_invitation_path
    end

    it 'displays admin only message' do
      expect(page).to have_content('Admins only!')
    end
  end

  context 'authenticated admin' do
    before do
      log_in(admin)
      click_link('Invite User')
    end

    it 'displays the page' do
      expect(page).to have_content('Invite User')
      expect(page).to have_css('#user_email')
      expect(page).to have_selector("input[type=submit][value='Send an invitation']")
    end

    context 'invites a user' do
      let!(:original_user_count) { User.count }
      let(:password) { 'Testing1' }

      before do
        fill_in('user_email', with: random_email)
        fill_in('user_name', with: random_name)
        click_button('Send an invitation')
      end

      it 'creates a user' do
        expect(page).to have_content("An invitation email has been sent to #{random_email}")
        expect(User.count).to eql(original_user_count + 1)
      end

      it 'allows user to join' do
        click_link('Logout')
        message = ActionMailer::Base.deliveries.last.to_s
        invitation_token_index = message.index('invitation_token') + 'invitation_token'.length + 1
        invitation_token = message[invitation_token_index...message.index("\r", invitation_token_index)]
        visit "users/invitation/accept?invitation_token=#{invitation_token}"
        expect(page).to have_content('Set your password')
        fill_in('user_password', with: password)
        fill_in('user_password_confirmation', with: password)
        click_button('Set my password')
        expect(page).to have_content('Your password was set successfully. You are now signed in.')
        click_link('Profile')
        expect(find('#user_email')).to have_content(random_email)
        expect(find('#user_name')).to have_content(random_name)
      end
    end
  end
end
