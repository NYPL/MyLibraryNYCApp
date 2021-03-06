# frozen_string_literal: true

class SearchSerializer < ActiveModel::Serializer
  cached

  self.root = false

  def serializable_hash
    {
      :teacher_sets => ActiveModel::ArraySerializer.new(object[:teacher_sets], @options),
      :facets => object[:facets],
      :errors => object[:errors]
    }
  end
end
