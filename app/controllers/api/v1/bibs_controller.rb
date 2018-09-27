class Api::V1::BibsController < ApplicationController
  def create_or_update_book
    render json: { status: 200, book_id: 0 }.to_json
  end

  def create_or_update_teacher_set
    render json: { status: 200, teacher_set_id: 0 }.to_json
  end

  def delete_book
    render json: { status: 200, book_id: 0 }.to_json
  end

  def delete_teacher_set
    render json: { status: 200, teacher_set_id: 0 }.to_json
  end
end
