# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::SchoolsController, :type => :controller do
  render_views

  let(:school) { School.create!(id: 1, name: "ZZ MLN STAFFtest", code: "MLNYC STAFF", address_line_1: "SASB") }
  let(:admin_user) { AdminUser.create!(email: 'admin@example.com', password: 'password') }

  before(:each) do
    sign_in admin_user
  end

  describe "POST create" do
    it 'create an school' do
      post :create, school: { id: 1, name: "ZZ MLN STAFFtest", code: "MLNYC STAFF", address_line_1: "SASB" }
      expect(School.all.count).to eq(1)
    end
  end

  describe "GET index" do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET show" do
    it 'show' do
      get :show, params: { id: school.id }
    end
  end

  describe "PUT activate" do
    it 'activate' do
      put :activate, params: { id: school.id }
    end
  end

  describe "PUT inactivate" do
    it 'inactivate' do
      put :inactivate, params: { id: school.id }
    end
  end
end
