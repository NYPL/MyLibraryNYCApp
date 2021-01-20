# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::TeacherSetsController, :type => :controller do
  render_views

  let(:teacher_set) { TeacherSet.create!(id: 1, bnumber: "54326", total_copies: 2, available_copies: 1) }
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

  describe "GET show" do
    it 'show' do
      get :show, params: { id: teacher_set.id }
    end
  end

  describe "PUT make_available" do
    it 'make_available' do
      put :make_available, params: { id: teacher_set.id }
    end
  end

  describe "PUT make_un_available" do
    it 'make_unavailable' do
      put :make_unavailable, params: { id: teacher_set.id }
    end
  end
end
