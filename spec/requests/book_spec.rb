require 'rails_helper'

RSpec.describe 'Book', type: :request do
  describe '#show' do
    let!(:book) { create(:book) }
    let(:get_url) { "http://localhost:3000/books/#{book_id}" }

    context 'the book exists' do
      let(:book_id) { book.id }

      it 'gets successfully' do
        get get_url
        expect(response).to be_successful
      end
    end

    context 'the book does not exist' do
      let(:book_id) { 0 }

      it 'returns a 404 not found' do
        get get_url
        expect(response.response_code).to eq(404)
      end
    end
  end
end
