require 'rails_helper'

RSpec.describe 'Book', type: :request do
  describe '#index' do
    let!(:book) { create(:book) }
    let(:get_url) { "http://localhost:3000/books" }

    # Fix this if we want to serve /books. Otherwise, remove the route. (@JC 2024-10-03)
    it 'returns a 406 not acceptable' do
      get get_url, headers: { "ACCEPT" => "text/html" }
      expect(response.response_code).to eq(406)
    end
  end

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

  describe '#book_details' do
    let!(:book) { create(:book) }
    let(:get_url) { "http://localhost:3000/book_details/#{book_id}" }

    context 'the book exists' do
      let(:book_id) { book.id }

      it 'gets successfully' do
        get get_url
        expect(response).to be_successful
      end
    end

    context 'the book does not exist' do
      let(:book_id) { 0 }

      # Maybe this should return a 404? (@JC 2024-10-03)
      it 'gets successfully' do
        get get_url
        expect(response.response_code).to eq(200)
      end
    end
  end

  ALLOWED_BOOK_PARAMS = %i[call_number cover_uri description details_url format isbn notes physical_description primary_language publication_date statement_of_responsibility sub_title title bnumber].freeze

  describe '#create' do
    let(:post_url) { "http://localhost:3000/books" }

    context 'with no params' do
      let(:book_params) { {} }

      it 'creates an empty book successfully' do
        post post_url, params: book_params
        expect(response.response_code).to eq(204)
        from_db = Book.last
        ALLOWED_BOOK_PARAMS.each { |param| expect(from_db.send(param)).to be_nil }
      end
    end

    context 'with all allowed params but catalog choice' do
      let(:book_params) { {} }

      before do
        ALLOWED_BOOK_PARAMS.each { |param| book_params[param] = "test_#{param}" }
      end

      it 'creates an empty book successfully' do
        post post_url, params: book_params
        expect(response.response_code).to eq(204)
        from_db = Book.last
        ALLOWED_BOOK_PARAMS.each { |param| expect(from_db.send(param)).to eq("test_#{param}") }
      end
    end

    context 'with catalog choice' do
      let(:book_params) { { :catalog_choice => 'some_catalog_choice' } }

      it 'creates the book successfully' do
        post post_url, params: book_params
        expect(response.response_code).to eq(204)
        from_db = Book.last
        from_db.catalog_choice = 'some_catalog_choice'
      end
    end

    context 'with only disallowed params' do
      let(:book_params) { { :fake_param => 'fake_value', :another_fake_param => 'another_fake_value'  } }

      it 'creates the empty book successfully' do
        post post_url, params: book_params
        expect(response.response_code).to eq(204)
        from_db = Book.last
        ALLOWED_BOOK_PARAMS.each { |param| expect(from_db.send(param)).to be_nil }
      end
    end
  end
end
