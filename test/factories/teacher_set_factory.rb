# frozen_string_literal: true

class Cranky::Factory
  def teacher_set
    define title: 'Example Teacher Set', bnumber: DateTime.now.strftime('%Q')
  end
end
