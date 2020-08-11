class Faq < ApplicationRecord
  acts_as_list scope: [:id, :questions, :answers]
end
