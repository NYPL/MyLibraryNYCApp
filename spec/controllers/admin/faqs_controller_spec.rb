require 'rails_helper'
require 'pry'
RSpec.describe Admin::FaqsController, :type => :controller do
  render_views

 let(:faq) { Faq.create!(id: 1, question: "test@email.com", answer: "ss",  position: 1)}
 let(:admin_user) { AdminUser.create!(email: 'admin@example.com', password: 'password')}

  before(:each) do
    sign_in admin_user
  end

  describe "POST create" do
    it 'create an faq' do
      post :create, faq: { id: 1, question: "test@email.com", answer: "ss",  position: 1 }
      expect(Faq.all.count).to eq(1)
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
      get :show, params: { id: faq.id }
    end
  end

  describe 'edit' do
    it 'renders user form' do
      get :edit, id: faq.to_param
      expect(assigns(:faq)).to eq faq
    end
  end

  describe 'update' do
    it 'updates user' do
      patch :update, { id: faq.to_param, faq: { id: 1, question: "test@email.com", answer: "ss",  position: 1 }}
      faq.reload
      expect(faq.id).to eq 1
    end
  end
end