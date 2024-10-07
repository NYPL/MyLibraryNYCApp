# frozen_string_literal: true

class HoldsController < ApplicationController
  include LogWrapper

  unless ENV['RAILS_ENV'] == 'test'
    before_action :check_ownership, only: [:show, :update]
    before_action :require_login, only: [:index, :new, :create, :check_ownership]
  end

  def index
    redirect_to root_url
  end

  # Performs the action of showing the detail of a single hold record, including
  # its date, status, and teacher set.  Is usually called by the teacher when checking
  # their holds history.  In routing terms, responds to a GET request on the
  # /holds/[hold id].json url.
  def show
    @hold = Hold.find_by_access_key(params[:id])
    head 401 if @hold.nil?
    render json: {
      hold: @hold.as_json,
      teacher_set: @hold.teacher_set.as_json,
      teacher_set_notes: @hold.teacher_set.teacher_set_notes
    }
  end

  # GET /holds/new.json
  def new
    @hold = Hold.new
    @hold.teacher_set = TeacherSet.find params[:teacher_set_id]
    render json: {
      hold: @hold,
      teacher_set: @hold.teacher_set
    }
  end

  # GET /holds/1/cancel.json
  def cancel_details
    @hold = Hold.find_by_access_key(params[:id])
    head 401 if @hold.nil?
    render json: {
      hold: @hold.as_json,
      teacher_set: @hold.teacher_set.as_json,
      teacher_set_notes: @hold.teacher_set.teacher_set_notes
    }
  end

  def holds_cancel_details; end

  def ordered_holds_details
    return if logged_in?

      if storable_location?
        store_user_location!
      end
      redirect_to "/signin"
    
  end

  ##
  # Create holds and update quantity column in holds.
  # Calculate available copies from quantity saves in teacherset table.
  def create
    begin
      # If user's school is inactive, then display an error message and redirect to teacher set detail page.
      is_school_active = current_user.school_id.present? ? School.find(current_user.school_id).active : false
      if !is_school_active
        render json: { status: :error, message:  "Your school is inactive. Please contact help@mylibrarynyc.org" }
        # stop processing further code, so new hold is not created,
        # and double-render runtime error is not caused in the rescue exception block.
        return
      end

      Hold.transaction do
        set = TeacherSet.find(params[:teacher_set_id])
        params.permit!
        @hold = set.holds.build(params[:hold])
        @hold.user = current_user

        unless params[:settings].nil?
          current_user.update(params.require(:settings).to_hash)
        end

        quantity = params[:query_params] && params[:query_params][:quantity] ? params[:query_params][:quantity] : @hold.quantity
        @hold.quantity = quantity.to_i
        if @hold.save
          teacher_set = @hold.teacher_set

          LogWrapper.log('INFO', {message: 'Teacher-set hold is created', method: __method__, 
                          teacher_set_id: @hold.teacher_set_id, hold_id: @hold.id, bnumber: teacher_set.bnumber })


          # Update teacher-set availability in DB
          teacher_set.update_teacher_set_availability_in_db('create', quantity.to_i)

          # Update teacher-set availability in elastic search document
          teacher_set.update_teacher_set_availability_in_elastic_search
          LogWrapper.log('DEBUG', {'message' => 'create: a pre-existing hold was saved', 'method' => 'app/controllers/holds_controller.rb.create'})
          # format.html { redirect_to hold_url(@hold.access_key), notice:
          #   'Your order has been received by our system and will soon be delivered to your school.\
          #   <br/><br/>Check your email inbox for a message with further details.' 
          # }
          render json: { hold: @hold.as_json, status: :created, location: @hold.as_json, message: "successfully" }
        else
          LogWrapper.log('DEBUG', {'message' => 'create: a new hold was generated', 'method' => 'app/controllers/holds_controller.rb.create'})
          render json: { hold: @hold.as_json, status: :unprocessable_entity, location: @hold.as_json }
          #format.html { render action: 'new' }
          #format.json { render json: @hold.errors, status: :unprocessable_entity }
        end
      end
    rescue => e
      render json: { status: :error, message: "We've encountered an error and were unable to confirm your order.\
                           Please try again later or email help@mylibrarynyc.org for assistance.", rails_error_message: e.message }
    end
  end

  def error_message(exception); end

  # Here calculate the teacher-set available_copies based on the current-user holds then saves in teacher-set table and cancel the current-user holds.
  def update
    @hold = Hold.find_by_access_key(params[:id])
    Hold.transaction do
      if !(c = params[:hold_change]).nil? && (c[:status] == 'cancelled')
          teacher_set = @hold.teacher_set

          LogWrapper.log('INFO', {message: 'Teacher-set hold is cancelled', method: __method__, 
                                  teacher_set_id: @hold.teacher_set_id, hold_id: @hold.id, bnumber: teacher_set.bnumber })
          # Update teacher-set availability in DB
          teacher_set.update_teacher_set_availability_in_db('cancelled', nil, current_user, @hold.id)
          @hold.cancel! c[:comment]
      end
      params.permit!

      if @hold.update!(params[:hold])
        # Update teacher-set availability in elastic search document
        teacher_set.update_teacher_set_availability_in_elastic_search
        render json: {
          hold: @hold.as_json,
          teacher_set: @hold.teacher_set.as_json,
          message: 'Your order was successfully updated.'
        }
      else
        render json: {
          status: :unprocessable_entity
        }
      end
    end
  end

  protected

  def check_ownership
    @hold = Hold.find_by_access_key(params[:id])
    # user_signed_in?
    if not logged_in?
      require_login

    elsif @hold.user != current_user
      flash[:error] = "You don't have permission to view/edit that order"
      respond_to do |format|
        format.html {
          redirect_to root_url
        }
        format.json {
          render json: { redirect_to: app_url }
        }
      end
    end
  end

  private

  # Strong parameters: protect object creation and allow mass assignment.
  def hold_params
    #not implementing in create yet: Hold.create(hold_params)
    params.permit(:date_required, :id, :quantity, :status, :teacher_set_id, :access_key, :user_id, :created_at, :updated_at, :hold)
  end

end
