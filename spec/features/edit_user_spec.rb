require 'rails_helper'

describe 'Edit user', feature: true do
  let!(:user) { create(:user) }
  let!(:admin) { create(:user, :admin) }
  let(:random_email) { Faker::Internet.email }
  let(:random_name) { Faker::Name.first_name }

  context 'non admin user' do
    before do
      log_in(user)
      click_link('Profile')
      click_link('Edit')
    end

    it 'allows the user to edit their own information' do
      fill_in('user_email', with: random_email)
      fill_in('user_name', with: random_name)
      click_button('Save changes')
      expect(page).to have_content('Successfully updated user.')
      expect(find('#user_email')).to have_content(random_email)
      expect(find('#user_name')).to have_content(random_name)
    end

    it 'errors when user leaves email blank' do
      fill_in('user_email', with: '')
      click_button('Save changes')
      expect(page).to have_content('Email can\'t be blank')
      expect(user.reload.email).not_to eql('')
    end

    it 'errors when user leaves name blank' do
      fill_in('user_name', with: '')
      click_button('Save changes')
      expect(page).to have_content('Name can\'t be blank')
      expect(user.reload.name).not_to eql('')
    end

    it 'errors when user enters taken email' do
      fill_in('user_email', with: admin.email)
      click_button('Save changes')
      expect(page).to have_content('Email has already been taken')
      expect(user.reload.name).not_to eql(admin.email)
    end
  end

  context 'admin user editing themselves' do
    before do
      log_in(admin)
      click_link('Profile')
      click_link('Edit')
    end

    it 'allows the admin to edit their own information' do
      fill_in('user_email', with: random_email)
      fill_in('user_name', with: random_name)
      click_button('Save changes')
      expect(page).to have_content('Successfully updated user.')
      expect(find('#user_email')).to have_content(random_email)
      expect(find('#user_name')).to have_content(random_name)
    end

    it 'errors when admin leaves email blank' do
      fill_in('user_email', with: '')
      click_button('Save changes')
      expect(page).to have_content('Email can\'t be blank')
      expect(user.reload.email).not_to eql('')
    end

    it 'errors when admin leaves name blank' do
      fill_in('user_name', with: '')
      click_button('Save changes')
      expect(page).to have_content('Name can\'t be blank')
      expect(user.reload.name).not_to eql('')
    end

    it 'errors when admin enters taken email' do
      fill_in('user_email', with: user.email)
      click_button('Save changes')
      expect(page).to have_content('Email has already been taken')
      expect(user.reload.name).not_to eql(user.email)
    end
  end

  context 'admin user editing others' do
    before do
      log_in(admin)
      click_link('Users')
      find("#user_#{user.id}").click_link('Edit')
    end

    it 'allows the admin to edit non admin users' do
      fill_in('user_email', with: random_email)
      fill_in('user_name', with: random_name)
      click_button('Save changes')
      expect(page).to have_content('Successfully updated user.')
      expect(find('#user_email')).to have_content(random_email)
      expect(find('#user_name')).to have_content(random_name)
      expect(admin.reload.email).not_to eql(random_email)
      expect(admin.reload.name).not_to eql(random_name)
    end

    it 'errors when admin leaves the user\'s email blank' do
      fill_in('user_email', with: '')
      click_button('Save changes')
      expect(page).to have_content('Email can\'t be blank')
      expect(user.reload.email).not_to eql('')
      expect(admin.reload.email).not_to eql('')
    end

    it 'errors when admin leaves the user\'s name blank' do
      fill_in('user_name', with: '')
      click_button('Save changes')
      expect(page).to have_content('Name can\'t be blank')
      expect(user.reload.name).not_to eql('')
      expect(admin.reload.name).not_to eql('')
    end

    it 'errors when admin enters taken email for the user' do
      fill_in('user_email', with: admin.email)
      click_button('Save changes')
      expect(page).to have_content('Email has already been taken')
      expect(user.reload.name).not_to eql(admin.email)
    end
  end

  context 'admin selects edit through #show view' do
    before do
      log_in(admin)
      click_link('Users')
      find("#user_#{user.id}").click_link(user.email)
      click_link('Edit')
    end

    it 'shows the user\'s information' do
      expect(find('#user_email').value).to eql(user.email)
      expect(find('#user_name').value).to eql(user.name)
    end
  end
end
