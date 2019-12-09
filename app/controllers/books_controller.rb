# frozen_string_literal: true

class BooksController < ApplicationController

  def index
    @books = Book.paginate(:page => params[:page])
  end

  
  def show
    @book = Book.find params[:id]
    render json: {
      :book => @book,
      :teacher_sets => @book.teacher_sets
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
