class TeacherSetNoteSerializer < ActiveModel::Serializer
  cached

  attributes :content

  delegate :cache_key, to: :object
end
