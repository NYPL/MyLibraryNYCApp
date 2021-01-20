# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::BooksController, :type => :controller do
  render_views

  let(:book) { Book.create!(id: 1, title: "You wouldn't") }
  let(:admin_user) { AdminUser.create!(email: 'admin@example.com', password: 'password') }

  before(:each) do
    sign_in admin_user
  end

  describe "GET index" do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
