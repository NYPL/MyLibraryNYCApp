class HoldSerializer < ActiveModel::Serializer

  attributes :id, :access_key, :date_required, :created_at, :status, :status_label, :quantity

  delegate :cache_key, to: :object
end
