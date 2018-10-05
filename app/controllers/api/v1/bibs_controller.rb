class Api::V1::BibsController < ApplicationController
  def create_or_update_teacher_sets
    render status: 200, json: {
      teacher_sets: [
        {
          id: 1,
          title: 'Example title 1'
        },
        {
          id: 2,
          title: 'Example title 2'
        }
      ]
    }.to_json
  end

  def delete_teacher_sets
    render status: 200, json: {
      teacher_sets: [
        {
          id: 1,
          title: 'Example title 1'
        },
        {
          id: 2,
          title: 'Example title 2'
        }
      ]
    }.to_json
  end
end
