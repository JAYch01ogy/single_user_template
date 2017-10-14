require 'rails_helper'

describe 'Password reset', feature: true do
  let!(:user) { create(:user) }
  let!(:old_password) { user.encrypted_password }
  let(:new_password) { 'Testing1' }

  before do
    visit user_session_path
    click_link('Forgot your password?')
  end

  it 'resets the users password' do
    expect(page).to have_content('Forgot your password?')
    fill_in('user_email', with: user.email)
    click_button('Send me reset password instructions')
    expect(page).to have_content('You will receive an email with instructions on how to reset your password in a few minutes.')
    message = ActionMailer::Base.deliveries.last.to_s
    reset_password_token_index = message.index('reset_password_token') + 'reset_password_token'.length + 1
    reset_password_token = message[reset_password_token_index...message.index("\"", reset_password_token_index)]
    visit "users/password/edit?reset_password_token=#{reset_password_token}"
    fill_in('user_password', with: new_password)
    fill_in('user_password_confirmation', with: new_password)
    click_button('Change my password')
    expect(page).to have_content('Your password has been changed successfully. You are now signed in.')
    expect(user.reload.encrypted_password).not_to eql(old_password)
    click_link('Profile')
    expect(find('#user_email')).to have_content(user.email)
    expect(find('#user_name')).to have_content(user.name)
  end
end
