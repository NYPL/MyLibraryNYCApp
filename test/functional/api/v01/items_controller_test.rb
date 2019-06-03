require 'test_helper'

class Api::ItemsControllerTest < MiniTest::Test

  extend Minitest::Spec::DSL
  include LogWrapper

  before do
    @controller = Api::V01::ItemsController.new
    @mintest_mock1 = MiniTest::Mock.new
    @mintest_mock2 = MiniTest::Mock.new
  end

  # Update availability method parses the item bodies to retrieve the bib id.
  # TEST1: Bib id not present in item body raise the bnumber not found in MLN db.
  describe '#test update availability method' do
    it 'test error message for update availability; bnumber not found in MLN db' do
      resp = nil
      error_message = [404, "bibIds are not found in MLN DB."]
      @mintest_mock1.expect(:call, [nil])
      total_count = 6
      available_count = 5
      t_set_bnumber = '45678'
      @mintest_mock2.expect(:call, [total_count, available_count, t_set_bnumber])

      @controller.stub :validate_request, @mintest_mock1 do
        @controller.stub :fetch_items_available_and_total_count, @mintest_mock2 do
          TeacherSet.stub :find_by_bnumber, [], ["b#{t_set_bnumber}"] do
            @controller.stub :render_error, [error_message[0], error_message[1]], error_message do
              resp = @controller.update_availability
            end
          end
        end
      end
      assert_nil(resp)
      @mintest_mock1.verify
      @mintest_mock2.verify
    end

    # Update availability method missing the item bodies.
    # TEST2: IF Request body is missing test parsing error message.
    it 'test parsing error for update availability method' do
      error_message = [400, "Parsing error: 765: unexpected token at ''"]
      error_resp = [status: error_message[0], json: { message: error_message[1]}]
      resp = nil
      mail_resp = OpenStruct.new(Message: '123', Multipart: false)
      @mintest_mock1.expect(:call, error_message)
      @controller.stub :validate_request, @mintest_mock1 do
        AdminMailer.stub :failed_items_controller_api_request, mail_resp, [{"test1": "test2"}, error_message, 'update_availability'] do
          @controller.stub :render_error, [error_message[0], error_message[1]], error_message do
            resp = @controller.update_availability
          end
        end
      end
      assert_nil(resp)
      @mintest_mock1.verify
    end
  end
end
