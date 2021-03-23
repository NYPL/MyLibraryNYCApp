## KeikoResponse Module defines all the System responses

module MlnResponse
  SYS_SUCCESS                               = lambda { |msg, data = {}| { code: '00000', success: true, message: msg,
                                                                          data: data, endpoint: 'TODO', timestamp: Time.zone.now} }
  SYS_FAILURE                               = lambda { |code, msg, data = {}| { code: code, success: false, message: msg,
                                                                                data: data, endpoint: 'TODO', timestamp: Time.zone.now} }
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
  ELASTIC_SEARCH_STANDARD_EXCEPTION         = {code: 'MLN-00011', msg: 'Unexpected exception occurred at elasticsearch. \n
                                                                        Please contact the system administrator.'}.freeze
  TEACHER_SET_NOTE_EXCEPTION                = {code: 'MLN-00012', msg: 'Exception occurred while creating the teacher-set note'}.freeze
  BIB_RECORD_NOT_FOUND                      = {code: 'MLN-00013', msg: 'Bib record not found in MLN DB'}.freeze
end