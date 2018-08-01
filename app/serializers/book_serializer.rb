class BookSerializer < ActiveModel::Serializer
  cached

  attributes :id, :cover_uri, :description, :details_url, :format, :isbn, :statement_of_responsibility, :title, :sub_title

  delegate :cache_key, to: :object
end
