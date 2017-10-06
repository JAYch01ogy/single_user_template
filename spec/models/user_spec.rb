require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:name) }

  it 'validates admin is false' do
    expect(user.admin).to be(false)
  end

  it 'validates email format' do
    user.email = 'invalid'
    expect(user).not_to be_valid
  end
end
