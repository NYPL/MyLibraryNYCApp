class FaqsController < ApplicationController
  def get_all_frequently_asked_questions
    Faq.get_faqs   
  end
end
