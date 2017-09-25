require 'rails_helper'

describe StaticPagesController, type: :controller do
  it 'redirects' do
    get :home
    expect(response.status).to eql(200)
  end
end
