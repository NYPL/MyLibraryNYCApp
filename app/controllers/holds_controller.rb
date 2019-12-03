# frozen_string_literal: true

require 'ruby_dig'

class HoldsController < ApplicationController
  include LogWrapper

  before_action :redirect_to_angular, only: [:show, :new, :cancel]
  before_action :check_ownership, only: [:show, :update]
  before_action :require_login, only: [:index, :new, :create, :check_ownership]

  def index
    LogWrapper.log('DEBUG', {'message' => 'index.start', 'method' => 'app/controllers/holds_controller.rb.index'})
    redirect_to root_url
  end

  # GET /holds/1.json
  def show
    LogWrapper.log('DEBUG', {'message' => 'show.start', 'method' => 'app/controllers/holds_controller.rb.show'})

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
    LogWrapper.log('DEBUG', {'message' => 'new.start', 'method' => 'app/controllers/holds_controller.rb.new'})
    @hold = Hold.new
    @hold.teacher_set = TeacherSet.find params[:teacher_set_id]
    render json: {
      hold: @hold,
      teacher_set: @hold.teacher_set
    }
  end

  # GET /holds/1/cancel.json
  def cancel
    LogWrapper.log('DEBUG', {'message' => 'cancel.start', 'method' => 'app/controllers/holds_controller.rb.cancel'})
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
    LogWrapper.log('DEBUG', {'message' => 'create.start', 'method' => 'app/controllers/holds_controller.rb.create'})

    begin
      # If currentuser school is inactive display error message and redirect to same page.
      is_school_active = current_user.school_id.present? ? School.find(current_user.school_id).active : false

      if !is_school_active
        render json: {:redirect_to => "#{app_url}#/teacher_sets/#{params[:teacher_set_id]}", :is_school_active => is_school_active}
        return
      end

      set = TeacherSet.find(params[:teacher_set_id])
      @hold = set.holds.build(params[:hold])
      @hold.user = current_user

      unless params[:settings].nil?
        current_user.update_attributes(params[:settings])
      end

      quantity = params.dig(:query_params, :quantity) ? params.dig(:query_params, :quantity) : @hold.quantity
      @hold.quantity = quantity.to_i
      @hold.teacher_set.available_copies = @hold.teacher_set.available_copies - quantity.to_i
      @hold.teacher_set.save!

      respond_to do |format|
        if @hold.save
          format.html { redirect_to hold_url(@hold.access_key), notice: 'Your order has been received by our system and will soon be delivered to your school.<br/><br/>Check your email inbox for a message with further details.' }
          format.json { render json: @hold, status: :created, location: @hold }
        else
          format.html { render action: 'new' }
          format.json { render json: @hold.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      respond_to do |format|
        format.json {
          render json: { error: "We've encountered an error and were unable to confirm your order. Please try again later or email help@mylibrarynyc.org for assistance.",
          rails_error_message: exception.message }.to_json, status: 500 }
        LogWrapper.log('ERROR', 'message' => exception.message)
      end
    end
  end

  def update
    LogWrapper.log('DEBUG', {'message' => 'update.start', 'method' => 'app/controllers/holds_controller.rb.update'})

    @hold = Hold.find_by_access_key(params[:id])

    unless (c = params[:hold_change]).nil?
      if c[:status] == 'cancelled'
        LogWrapper.log('DEBUG', {'message' => 'cancelling hold', 'method' => 'app/controllers/holds_controller.rb.update'})
        @hold.cancel! c[:comment]
      end
    end

    respond_to do |format|
      if @hold.update_attributes(params[:hold])
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
    LogWrapper.log('DEBUG', {'message' => 'check_ownership.start', 'method' => 'app/controllers/holds_controller.rb.check_ownership'})
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
    params.permit(:date_required)
  end

end
