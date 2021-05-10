# frozen_string_literal: true

class HoldsController < ApplicationController
  include LogWrapper

  unless ENV['RAILS_ENV'] == 'test'
    before_action :redirect_to_angular, only: [:show, :new, :cancel]
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
      hold: @hold,
      teacher_set: @hold.teacher_set,
      teacher_set_notes: @hold.teacher_set.teacher_set_notes
    }, serializer: HoldExtendedSerializer, root: false
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
  def cancel
    @hold = Hold.find_by_access_key(params[:id])
    head 401 if @hold.nil?
    render json: {
      hold: @hold,
      teacher_set: @hold.teacher_set,
      teacher_set_notes: @hold.teacher_set.teacher_set_notes
    }
  end


  ##
  # Create holds and update quantity column in holds.
  # Calculate available copies from quantity saves in teacherset table.
  def create
    begin
      # If user's school is inactive, then display an error message and redirect to teacher set detail page.
      is_school_active = current_user.school_id.present? ? School.find(current_user.school_id).active : false
      if !is_school_active
        render json: {:redirect_to => "#{app_url}#/teacher_sets/#{params[:teacher_set_id]}", :is_school_active => is_school_active}
        # stop processing further code, so new hold is not created,
        # and double-render runtime error is not caused in the rescue exception block.
        return
      end

      set = TeacherSet.find(params[:teacher_set_id])
      params.permit!
      @hold = set.holds.build(params[:hold])
      @hold.user = current_user

      unless params[:settings].nil?
        current_user.update(params.require(:settings).to_hash)
      end

      quantity = params[:query_params] && params[:query_params][:quantity] ? params[:query_params][:quantity] : @hold.quantity
      @hold.quantity = quantity.to_i

      respond_to do |format|
        if @hold.save
          # Update teacher-set available_copies while creating the teacher-set order copies.
          @hold.teacher_set.available_copies = @hold.teacher_set.available_copies - quantity.to_i
          @hold.teacher_set.availability = TeacherSet::UNAVAILABLE if @hold.teacher_set.available_copies <= 0
          @hold.teacher_set.save!
          LogWrapper.log('DEBUG', {'message' => 'create: a pre-existing hold was saved', 'method' => 'app/controllers/holds_controller.rb.create'})
          format.html { redirect_to hold_url(@hold.access_key), notice:
            'Your order has been received by our system and will soon be delivered to your school.\
            <br/><br/>Check your email inbox for a message with further details.' 
          }
          format.json { render json: @hold, status: :created, location: @hold }
        else
          LogWrapper.log('DEBUG', {'message' => 'create: a new hold was generated', 'method' => 'app/controllers/holds_controller.rb.create'})
          format.html { render action: 'new' }
          format.json { render json: @hold.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      error_message(exception)
    end
  end


  def error_message(exception)
    # Note: don't need an explicit return here
    respond_to do |format|
      format.html {}
      format.json {
        render json: { error: "We've encountered an error and were unable to confirm your order.\
          Please try again later or email help@mylibrarynyc.org for assistance.", rails_error_message: exception.message }.to_json, status: 500 
      }
    end
  end

  
  # Here calculate the teacher-set available_copies based on the current-user holds than saves in teacher-set table and cancel the current-user holds.
  def update
    @hold = Hold.find_by_access_key(params[:id])

    unless (c = params[:hold_change]).nil?
      if c[:status] == 'cancelled'
        # Update teacher-set available copies while cancelling the hold.
        user_holds_count = @hold.teacher_set.holds_count_for_user(current_user, @hold.id).to_i
        @hold.teacher_set.available_copies = @hold.teacher_set.available_copies.to_i + user_holds_count
        @hold.teacher_set.availability = TeacherSet::AVAILABLE if @hold.teacher_set.available_copies > 0
        @hold.teacher_set.save!
        LogWrapper.log('DEBUG', {'message' => 'cancelling hold', 'method' => 'app/controllers/holds_controller.rb.update'})
        @hold.cancel! c[:comment]
      end
    end
    respond_to do |format|
      params.permit!
      if @hold.update(params[:hold])
        format.html { redirect_to @hold, notice: 'Your order was successfully updated.' }
        format.json { render json: @hold }
      else
        format.html { render action: 'edit' }
        format.json { render json: @hold.errors, status: :unprocessable_entity }
      end
    end
  end

  protected

  def check_ownership
    @hold = Hold.find_by_access_key(params[:id])

    if not user_signed_in?
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
