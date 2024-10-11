# frozen_string_literal: true

require 'test_helper'

class DocumentTest < ActionController::TestCase

  setup do
    @document = documents(:one)
    @document2 = documents(:two)
    @document3 = documents(:three)
  end


  test 'Get document from google client' do
    resp = nil
    expected_google_document = "Mylibrary-nyc document"
    document_id = '133iBzIYM_GG5OCXkuF4vKwSYRFaH3gd8Q_kuDrqT7Iu4U'
    GoogleApiClient.stub(:export_file, expected_google_document, [document_id, "application/pdf"]) do
      resp = @document.google_document
    end
    assert_equal(expected_google_document, resp)
  end


  test 'Get calendar_event from document table' do
    assert_equal('calendar_of_events', Document.calendar_of_events.event_type)
  end


  test 'Event type already exist in document table' do
    @document.event_type_already_exist
    e_type = @document.event_type.titleize
    error_msg = "#{e_type} type already created. Please use another type, or use the 'edit' link if you are trying to update #{e_type}"
    assert_equal(@document.errors.messages[:event_type], [error_msg])
  end


  test 'Event type should not be blank' do
    @document3.validate_event_type
    assert_equal(@document3.errors.messages[:event_type], ['Please select event_type'])
  end


  test 'Google document not found' do
    error_obj = Struct.new(:status_code, :body).new(404, 'body')
    email = JSON.parse(ENV.fetch('MLN_GOOGLE_ACCCOUNT', nil))['client_email']
    error_msg = "There was an error accessing this file. Please check this URL is valid, and that the document is shared with #{email}"
    resp = @document.google_client_error_message(error_obj)
    assert_equal(error_msg, resp)
  end
end
