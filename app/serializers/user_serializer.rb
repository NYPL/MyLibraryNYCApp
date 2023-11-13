# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  cached

  attributes :id, :email, :first_name, :last_name, :alt_email, :home_library,
             :school_id,:barcode, :status, :password
  delegate :cache_key, to: :object
end
