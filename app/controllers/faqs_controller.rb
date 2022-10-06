# frozen_string_literal: true

class FaqsController < ApplicationController

  def show
    if storable_location?
      store_user_location!
    end
    # Get all frequently asked questions by position ASC order.
    render json: { faqs: Faq.get_faqs }
  end
end
