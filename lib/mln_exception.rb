module MlnException

  # Mln Application Exceptions

  class MlnException < StandardError
    attr_accessor :code
    attr_accessor :detailed_msg
    def initialize(code, message)
      super(message)
      @code = code
    end
  end

  class DBException < MlnException
    
  end

  class InvalidInputException < MlnException
    # Invalid input Arguments Exception
  end

  class ElasticsearchException < MlnException
    # Any Exception during ElasticSearch call
  end

  class TeacherSetNoteException < MlnException

  end

  class BibRecordNotFoundException < MlnException

  end
end
