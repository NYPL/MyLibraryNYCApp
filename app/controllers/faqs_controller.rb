# frozen_string_literal: true

class FaqsController < ApplicationController

  def frequently_asked_questions
    # Get all frequently asked questions by position ASC order.
    Faq.get_faqs   
  end
end
