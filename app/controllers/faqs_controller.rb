# frozen_string_literal: true

class FaqsController < ApplicationController
  def frequently_asked_questions
    Faq.get_faqs   
  end
end
