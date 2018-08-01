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
end
