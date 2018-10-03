class HoldsController < ApplicationController  
  include LogWrapper

  
  before_filter :redirect_to_angular, only: [:show, :new, :cancel]
  before_filter :check_ownership, only: [:show, :update]
  before_filter :require_login, only: [:index, :new, :create]  

  def index
    redirect_to root_url
  end

  # GET /holds/1.json
  def show
    # @hold = Hold.find(params[:id])
    @hold = Hold.find_by_access_key(params[:id])
    head 401 if @hold.nil?

=begin
    render json: {
      :teacher_set => @hold.teacher_set,
      :active_hold => @hold,
      :user => current_user
      # :teacher_set_notes => @set.teacher_set_notes,
      # :books => @set.books
    }, serializer: HoldSerializer
=end
    render json: {
      :hold => @hold,
      :teacher_set => @hold.teacher_set,
      :teacher_set_notes => @hold.teacher_set.teacher_set_notes
    }, serializer: HoldExtendedSerializer, root: false
  end

  # GET /holds/new.json
  def new
    @hold = Hold.new
    @hold.teacher_set = TeacherSet.find params[:teacher_set_id]
    render json: {
      :hold => @hold,
      :teacher_set => @hold.teacher_set
    }
  end
  
  # GET /holds/1/cancel.json
  def cancel
    @hold = Hold.find_by_access_key(params[:id])
    head 401 if @hold.nil?
    render json: {
      :hold => @hold,
      :teacher_set => @hold.teacher_set,
      :teacher_set_notes => @hold.teacher_set.teacher_set_notes
    }
  end

  def create
    begin
      set = TeacherSet.find(params[:teacher_set_id])
      @hold = set.holds.build(params[:hold])
      @hold.user = current_user
      unless params[:settings].nil?
        current_user.update_attributes(params[:settings])
      end
      
      respond_to do |format|
        if @hold.save
          format.html { redirect_to hold_url(@hold.access_key), notice: 'Your order has been received by our system and will soon be delivered to your school.<br/><br/>Check your email inbox for a message with further details.' }
          format.json { render json: @hold, status: :created, location: @hold }
        else
          format.html { render action: "new" }
          format.json { render json: @hold.errors, status: :unprocessable_entity }
        end
      end
    rescue => exception
      respond_to do |format|
          format.json {   render json: {error: "We've encountered an error and were unable to confirm your order. Please try again later or email help@mylibrarynyc.org for assistance.
            ", rails_error_message: exception.message}.to_json, status: 500}
      LogWrapper.log('ERROR','message' => exception.message)
      end
    end
  end

  def update
    # @hold = Hold.find(params[:id])
    @hold = Hold.find_by_access_key(params[:id])
    puts "update? #{@hold}"

    unless (c = params[:hold_change]).nil?
      if c[:status] == 'cancelled'
        puts "cancelling hold: #{c} => #{@hold}"
        @hold.cancel! c[:comment]
      end
    end

    respond_to do |format|
      if @hold.update_attributes(params[:hold])
        format.html { redirect_to @hold, notice: 'Your order was successfully updated.' }
        format.json { render json: @hold }
      else
        format.html { render action: "edit" }
        format.json { render json: @hold.errors, status: :unprocessable_entity }
      end
    end
  end
  
  protected

  def check_ownership
    @hold = Hold.find_by_access_key(params[:id])
    # @hold = Hold.find(params[:id])
    
    if not user_signed_in?
      require_login
      
    elsif @hold.user != current_user
      flash[:error] = "You don't have permission to view/edit that order"      
      respond_to do |format|
        format.html {
          redirect_to root_url
        }
        format.json {
          render json: {:redirect_to => app_url}
        }
      end
    end
  end
end
