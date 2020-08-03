class PokeModel1Job < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    #User::DoSomethingAwesome.call(user)
    Rails.logger.debug "#{self.class.name}: I'm performing my job with arguments: #{args.inspect}"
  end
end
