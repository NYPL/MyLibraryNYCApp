# frozen_string_literal: true

class PokeModel1Job < ApplicationJob
  queue_as :default

  def perform(*args)
    # perform code on its own thread
    Rails.logger.debug "#{self.class.name}: I'm performing my job with arguments: #{args.inspect}"
  end
end
