# frozen_string_literal: true

class TeacherSetSerializer < ActiveModel::Serializer

  # unless MlnConfigurationController.new.feature_flag_config('teacherset.data.from.elasticsearch.enabled')
  #   cached
  # end

  attributes :id, :availability, :availability_string, :description, :details_url, :primary_language, :subject_key, :title, :suitabilities_string, 
             :call_number, :physical_description, :set_type, :contents, :total_copies,
             :available_copies, :language
  has_many :teacher_set_notes
  has_many :books

  # If controller specifies :include_books=>false for perf, don't include books
  def include_books?
    @options[:include_books].nil? ? true : @options[:include_books]
  end


  def include_contents?
    @options[:include_contents].nil? ? true : @options[:include_contents]
  end

  
  # Can't just delegate cache_key to object because some serializations have books & some don't
  def cache_key
    [object, @options[:include_books], @options[:include_contents]]
  end
end
