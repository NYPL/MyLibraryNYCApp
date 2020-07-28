class PokeModel1Job < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.debug "#{self.class.name}: I'm performing my MLN2019 job with arguments: #{args.inspect}"
  end
end
