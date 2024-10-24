require 'rails_helper'

RSpec.describe 'Hold', type: :request do
  describe '#index' do
    let(:get_url) { "http://localhost:3000/holds" }

    it 'redirects' do
      get get_url
      expect(response.response_code).to eq(302)
    end
  end

  describe '#show' do
    let(:get_url) { "http://localhost:3000/holds/#{hold_access_key}" }
    let!(:hold) { create(:hold) }

    context 'the hold exists' do
      let(:hold_access_key) { hold.access_key }

      it 'gets successfully' do
        get get_url
        expect(response).to be_successful
      end
    end

    context 'the hold does not exist' do
      let(:hold_access_key) { 'unknown' }

      # probably should be a 404 (@JC - 2020-07-07)
      it 'returns a 500 error' do
        get get_url
        expect(response.code).to eq('500')
      end
    end
  end

  describe '#new' do
    let(:get_url) { "http://localhost:3000/holds/new.json" }

    it 'gets successfully' do
      get get_url
      expect(response).to be_successful
    end
  end



end
