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
      log_in(user)
      visit users_path
    end

    it 'displays admin only message' do
      expect(page).to have_content('Admins only!')
    end
  end

  context 'authenticated admin' do
    before do
      create_list(:user, 3)
      log_in(admin)
      click_link('Users')
    end

    it 'displays the page' do
      User.all.each do |user|
        expect(page).to have_content(user.email)
        expect(page).to have_content(user.name)
      end
    end

    it 'displays admin profile' do
      click_link(admin.email)
      expect(page).to have_content('Profile (admin)')
      expect(find('#user_email')).to have_content(admin.email)
      expect(find('#user_name')).to have_content(admin.name)
    end

    it 'displays selected user profile' do
      click_link(User.first.email)
      expect(page).to have_content('Profile')
      expect(find('#user_email')).to have_content(User.first.email)
      expect(find('#user_name')).to have_content(User.first.name)
    end

    context 'delete users' do
      let!(:prior_user_count) { User.count }
      let!(:user_being_deleted) { User.find(2) }

      it 'allows user deletion of non admin user' do
        find('#user_2').click_link('Delete')
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content('Successfully deleted user.')
        expect(User.count).to eql(prior_user_count - 1)
        expect(page).not_to have_content(user_being_deleted.email)

        User.all.each do |user|
          expect(page).to have_content(user.email)
          expect(page).to have_content(user.name)
        end
      end

      it 'prevents deletion of admin user' do
        find("#user_#{admin.id}").click_link('Delete')
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content('You cannot delete the admin user.')
        expect(User.count).to eql(prior_user_count)
        expect(page).to have_content(admin.email)
      end
    end
  end
end
