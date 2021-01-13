# frozen_string_literal: true

class BooksController < ApplicationController

  def index
    @books = Book.paginate(:page => params[:page])
  end

  
  def show
    @book = Book.find params[:id]
    bib_code_3_vals = @book.teacher_sets.collect{|i| i.bib_code_3}
    # If the bib record has "n" or "e" in the "Bib Code 3 field" we should not show the "View in catalog" link on the book show page.
    render json: {
      :book => @book,
      :teacher_sets => @book.teacher_sets,
      :show_catalog_link => !(['n', 'e'] & bib_code_3_vals).any?
    }
  end


  def create
    Book.create(book_params)
  end

  private

  # Strong parameters: protect object creation and allow mass assignment.
  def book_params
    params.permit(:call_number, :cover_uri, :description, :details_url, :format, :id, :isbn, :notes, :physical_description, 
                  :primary_language, :publication_date, :statement_of_responsibility, :sub_title, :title, :catalog_choice, :bnumber)
  end
end
