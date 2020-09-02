# frozen_string_literal: true

class PokeModel1Job < ApplicationJob
  queue_as :default

  around_perform :around_cleanup

  # retry_on CustomAppException # defaults to 3s wait, 5 attempts
  # discard_on ActiveJob::DeserializationError


  def perform(user: nil, **args)
    puts "PokeModel1Job.perform"
    # perform code on its own thread
    Rails.logger.debug "#{self.class.name}: I'm performing my job with arguments: #{args.inspect}"
    puts "PokeModel1Job.perform: user=#{user}"

    # if might raise exceptions, like CustomAppException or
    # ActiveJob::DeserializationError, then can rescue or discard
  end


  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    # Do something with the exception
  end


  private
    def around_cleanup
      # Do something before perform
      yield
      # Do something after perform
    end
end
