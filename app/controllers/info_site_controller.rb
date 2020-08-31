# frozen_string_literal: true

class InfoSiteController < ApplicationController

  # Display's info-site home page
  def index; end


  # Display's mylibrarynyc information
  def about; end


  # Display's mylibrarynyc contact's information
  def contacts; end


  # Display's mylibrarynyc school's information
  def participating_schools; end
  

  def digital_resources; end


  def help; end

  
  def faq
    @faqs = FaqsController.new.frequently_asked_questions
  end
end
