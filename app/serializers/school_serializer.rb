# frozen_string_literal: true

class SchoolSerializer < ActiveModel::Serializer
  cached

  attributes :id, :name

  delegate :cache_key, to: :object
end
