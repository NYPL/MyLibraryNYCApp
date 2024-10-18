require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe '#index' do
    let(:get_url) { "http://localhost:3000" }

    it 'gets successfully' do
      get get_url
      expect(response).to be_successful
    end
  end

  describe '#mln_file_names' do
    let(:get_url) { "http://localhost:3000/home/get_mln_file_names" }

    it 'gets successfully' do
      get get_url
      expect(response).to be_successful
    end
  end

  describe '#swagger_docs' do
    let(:get_url) { "http://localhost:3000/docs/mylibrarynyc" }

    it 'gets successfully' do
      get get_url
      expect(response).to be_successful
    end
  end

  describe '#digital_resources' do
    let(:get_url) { "http://localhost:3000/help/access-digital-resources" }

    it 'gets successfully' do
      get get_url
      expect(response).to be_successful
    end
  end

  describe '#help' do
    let(:get_url) { "http://localhost:3000/contact" }

    it 'gets successfully' do
      get get_url
      expect(response).to be_successful
    end
  end

  describe '#faq_data' do
    let(:get_url) { "http://localhost:3000/faq" }

    it 'gets successfully' do
      get get_url
      expect(response).to be_successful
    end
  end

  describe '#newsletter_confirmation' do
    let(:get_url) { "http://localhost:3000/newsletter_confirmation" }

    it 'gets successfully' do
      get get_url
      expect(response).to be_successful
    end
  end

  describe '#newsletter_confirmation_msg' do
    let(:get_url) { "http://localhost:3000/home/newsletter_confirmation_msg" }

    it 'gets successfully' do
      get get_url
      expect(response).to be_successful
    end
  end

  describe '#calendar_event' do
    let(:get_url) { "http://localhost:3000/home/calendar_event" }

    it 'gets successfully' do
      get get_url
      expect(response).to be_successful
    end
  end

  describe '#mln_calendar' do
    let(:get_url) { "http://localhost:3000/home/calendar_event/#{filename}" }
    let(:filename) { 'some_filename.pdf' }

    it 'gets successfully' do
      get get_url
      expect(response).to be_successful
    end
  end

  describe '#menu_of_services' do
    let(:get_url) { "http://localhost:3000/menu_of_services/#{filename}" }

    context 'filename is menu_of_services.pdf' do
      let(:filename) { 'menu_of_services.pdf' }

      it 'gets successfully' do
        get get_url
        expect(response).to be_successful
      end
    end

    context 'filename is something else' do
      let(:filename) { 'something_else.pdf' }

      it 'redirects' do
        get get_url
        expect(response.response_code).to eq(302)
      end
    end
  end

end
