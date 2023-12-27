# frozen_string_literal: true

# KeikoResponse Module defines all the System responses

module MlnResponse
  SYS_SUCCESS = lambda do |msg, detailed_msg = nil, data = {}| 
    { code: '00000', success: true, message: "#{msg} #{detailed_msg}", data: data, timestamp: Time.zone.now } 
  end

  SYS_FAILURE = lambda do |code, msg, detailed_msg = nil, data = {}| 
    { code: code, success: false, message: "#{msg} #{detailed_msg}", data: data, timestamp: Time.zone.now }
  end

  API_BAD_REQUEST                           = {code: 'MLN-00001', msg: 'Bad Request.'}.freeze
  API_AUTHENTICATION_FAILURE                = {code: 'MLN-00002', msg: 'Authentication failed.'}.freeze
  INVALID_INPUT                             = {code: 'MLN-00003', msg: 'Invalid Input.'}.freeze
  BIB_NUMBER_EMPTY                          = {code: 'MLN-00004', msg: 'Bnumber is empty.'}.freeze
  TITLE_EMPTY                               = {code: 'MLN-00005', msg: 'Title is empty.'}.freeze
  PHYSICAL_DESCRIPTION_EMPTY                = {code: 'MLN-00006', msg: 'Physical description is empty.'}.freeze
  TEACHERSET_SETTYPE_ERROR                  = {code: 'MLN-00007', msg: 'Set-type value not updated'}.freeze
  EMPTY_REQUEST_BODY                        = {code: 'MLN-00008', msg: 'Requested body is missing'}.freeze
  MLN_INVALID_REQUEST_BODY                  = {code: 'MLN-00009', msg: 'Request body is invalid'}.freeze
  UNEXPECTED_EXCEPTION                      = {code: 'MLN-00010', msg: 'Mln system error. Please contact the system administrator.'}.freeze
  ELASTIC_SEARCH_STANDARD_EXCEPTION         = {code: 'MLN-00011', msg: 'Unexpected exception occurred at elasticsearch.
    Please contact the system administrator.'}.freeze
  TEACHER_SET_NOTE_EXCEPTION                = {code: 'MLN-00012', msg: 'Exception occurred while creating the teacher-set note'}.freeze
  BIB_RECORD_NOT_FOUND                      = {code: 'MLN-00013', msg: 'Bib record not found in MLN DB'}.freeze
  TEACHER_SET_NOT_FOUND_IN_ES               = {code: 'MLN-00014', msg: 'Teacherset not found in elastic-search'}.freeze
  BIB_RECORD_SUPPRESSED_REMOVED_FROM_MLN     = {code: 'MLN-00015', msg: 'Bib is suppressed in Sierra; Bib was removed from MyLibraryNYC'}.freeze
  BIB_RECORD_SUPPRESSED_NOT_ADDED_TO_MLN     = {code: 'MLN-00016', msg: 'Bib is suppressed in Sierra; Bib was not added to MyLibraryNYC'}.freeze
  GENERIC_SERVER_ERROR                       = {code: 'MLN-00017', msg: 'Generic server error from sierra'}.freeze
end
