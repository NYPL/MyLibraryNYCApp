# frozen_string_literal: true

class BooksController < ApplicationController

  def index
    @books = Book.paginate(:page => params[:page])
  end

  def show
    if storable_location?
      store_user_location!
    end
    @book = Book.find params[:id]
    # If the bib record has "n" or "e" in the "Bib Code 3 field" we should not show the "View in catalog" link on the book show page.
    render json: {
      :book => @book.as_json,
      :teacher_sets => @book.teacher_sets.as_json,
      :show_catalog_link => !%w[n e].include?(@book.bib_code_3)
    }
  end

  def create
    Book.create(book_params)
  end

  def book_details; end

  private

  # Strong parameters: protect object creation and allow mass assignment.
  def book_params
    params.permit(:call_number, :cover_uri, :description, :details_url, :format, :id, :isbn, :notes, :physical_description, 
                  :primary_language, :publication_date, :statement_of_responsibility, :sub_title, :title, :catalog_choice, :bnumber)
  end
end
