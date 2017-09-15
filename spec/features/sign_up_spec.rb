require 'rails_helper'

describe 'Sign up', feature: true do
  before do
    visit new_user_registration_path
  end

  it 'displays the page' do
    expect(page).to have_content('Sign up')
    expect(page).to have_css('#user_email')
    expect(page).to have_css('#user_password')
    expect(page).to have_css('#user_password_confirmation')
    expect(page).to have_selector("input[type=submit][value='Sign up']")
  end

  it 'allows user sign up' do
    fill_in('user_email', with: 'Test@Test.com')
    fill_in('user_password', with: 'Testing1')
    fill_in('user_password_confirmation', with: 'Testing1')
    click_button('Sign up')
    expect(page).to have_content('Welcome! You have signed up successfully.')
    expect(page).to have_content('Home')
    expect(page).to have_content('Edit profile')
    expect(page).to have_content('Logout')
    expect(page).not_to have_content('Sign up')
    expect(page).not_to have_content('Login')
  end
end
