class FaqsController < ApplicationController
	def get_all_frequently_asked_questions
		Faq.all		
	end
end
