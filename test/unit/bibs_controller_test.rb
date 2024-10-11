# frozen_string_literal: true

require 'test_helper'

class BibsControllerTest < Minitest::Test
  extend Minitest::Spec::DSL
  include LogWrapper

  def req_body_for_item
    [{
      'nyplSource' => 'sierra-nypl',
      'id' => '998',
      'bibIds' => [
        '998'
      ],
      'status' => {
        'code' => '-', 
        'display' => 'AVAILABLE', 
        'duedate' => '2011-04-26T16:16:00-04:00'
      }
    }]
  end

  def delete_teacher_set_response
    { teacher_sets: [{ id: 733, bnumber: "b998", title: "QA Teacher Set for MLN-662  AC#4" }] }
  end
end
