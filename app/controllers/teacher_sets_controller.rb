# frozen_string_literal: true

class TeacherSetsController < ApplicationController

  include TeacherSetsEsHelper

  before_action :redirect_to_angular, only: [:index, :show] unless ENV['RAILS_ENV'] == 'test'

  ##
  # GET /teacher_sets.json
  # Called on loading the teacher set list page and when the user selects
  # a facet to filter by.
  def index
    # Feature flag: 'teacherset.data.from.elasticsearch.enabled = true' means gets teacher-set documents from elastic search.
    # teacherset.data.from.elasticsearch.enabled = false means gets teacher-set data from database.
    if MlnConfigurationController.new.feature_flag_config('teacherset.data.from.elasticsearch.enabled')
      LogWrapper.log('INFO', {'message' => "Calling elastic search to get teacher-sets", 
                              'method' => 'app/controllers/teacher_sets_controller.rb.index'})
  
      # Get teachersets and facets from elastic search
      teacher_sets, @facets = ElasticSearch.new.get_teacher_sets_from_es(params)
      @teacher_sets = teacher_sets_from_elastic_search_doc(teacher_sets)
    else
      LogWrapper.log('INFO', {'message' => "Calling database to get teacher-sets", 
                              'method' => 'app/controllers/teacher_sets_controller.rb.index'})
      @teacher_sets = TeacherSet.for_query params
      @facets = TeacherSet.facets_for_query @teacher_sets
    end
    # Determine what facets are selected based on query string
    @facets.each do |f|
      f[:items].each do |v|
        k = f[:label].underscore
        v[:selected] = params.keys.include?(k) && params[k].include?(v[:value].to_s)
      end
    end

    @facets = teacher_set_facets(params)
    # Attach custom :q param to each facet with query params to be applied to that link
    if MlnConfigurationController.new.feature_flag_config('teacherset.data.from.elasticsearch.enabled')
      render json: { teacher_sets: @teacher_sets, facets: @facets }
    else
      render json: { teacher_sets: @teacher_sets, facets: @facets }, serializer: SearchSerializer, include_books: false, include_contents: false
    end
  rescue StandardError => e
    LogWrapper.log('ERROR', {'message' => "Error occured in teacherset controller. Error: #{e.message}, backtrace: #{e.backtrace}", 
                             'method' => 'app/controllers/teacher_sets_controller.rb.index'})
    render json: {
      errors: {error_message: "We've encountered an error. Please try again later or email help@mylibrarynyc.org for assistance."},
      teacher_sets: {},
      facets: {}
    }, serializer: SearchSerializer, include_books: false, include_contents: false
  end


  # teacher set facets
  def teacher_set_facets(params)
    @facets.each do |f|
      f[:items].each do |v|
        l = f[:label].underscore
        q = {}
        q[:keyword] = params[:keyword] if params[:keyword]
        q[:grade_begin] = params[:grade_begin] if params[:grade_begin]
        q[:grade_end] = params[:grade_end] if params[:grade_end]
        q[:lexile_begin] = params[:lexile_begin] if params[:lexile_begin]
        q[:lexile_end] = params[:lexile_end] if params[:lexile_end]

        @facets.each do |ff|
          ll = ff[:label].underscore
          q[ll] = []
          ff[:items].each do |vv|
            # if current facet
            if ll == l && vv == v
              # add if not selected
              q[ll] << vv[:value] if !vv[:selected]
            else
              q[ll] << vv[:value] if vv[:selected]
            end
          end
          if q[ll].empty?
            q.delete ll
          end
        end
        v[:q] = q
        v[:path] = teacher_sets_path(v[:q])
      end
    end
  end


  # GET /teacher_sets/1.json
  def show
    # Stores the current location in session, so if an un-authenticated user
    # tries to order this teacher set, we can ask the user to sign in, and
    # then redirect back to this teacher_set detail page.
    if storable_location?
      store_user_location!
    end

    @set = TeacherSet.find(params[:id])
    @active_hold = nil
    user_has_ordered_max = false

    # limits book titles to unique ones to mask the problem we've been having
    # with the teacher_sets detail page puling up duplicate child book records.
    ts_books = @set.books.select('DISTINCT ON (books.cover_uri) books.cover_uri, books.id, books.title')

    # Max copies value is configured in elastic beanstalk.
    # Max_copies_requestable is the maximum number of teachersets can request.
    max_copies_requestable = ENV['MAXIMUM_COPIES_REQUESTABLE'] || 5

    if @set.held_by? current_user
      @active_hold = @set.pending_holds_for_user(current_user).first
    end

    # ts_holds_count is the number of holds currently held in the database for this teacher set.
    ts_holds_count = @set.holds_count_for_user(current_user)
    user_has_ordered_max = (ts_holds_count.to_i >= max_copies_requestable.to_i)

    # Teacher set available copies less than configured value, we should show ts available_copies count in teacherset order dropdown.
    max_copies_requestable = [max_copies_requestable.to_i - ts_holds_count.to_i, @set.available_copies.to_i].min

    # Button should be disabled after teacher has ordered maximum.
    allowed_quantities = user_has_ordered_max ? [] : (1..max_copies_requestable.to_i).to_a

    render json: {
      teacher_set: @set,
      active_hold: @active_hold,
      user: current_user,
      allowed_quantities: allowed_quantities,
      books: ts_books
    }, serializer: TeacherSetForUserSerializer, root: 'teacher_set'
  end


  # Gets current user teacherset holds from database.
  def teacher_set_holds
    @set = TeacherSet.find(params[:id])
    @holds = @set.holds_for_user(current_user)
  end


  # TODO: Fix: create currently fails our functional tests.
  def create
    TeacherSet.create(teacherset_params)
  end

  private

  # Strong parameters: protect object creation and allow mass assignment.
  def teacherset_params
    params.permit(:slug, :grade_begin, :grade_end, :availability, :call_number, :description, :details_url, :edition, :id,
                  :isbn, :language, :lexile_begin, :lexile_end, :notes, :physical_description, :primary_language, :publication_date,
                  :publisher, :series, :statement_of_responsibility, :sub_title, :title, :books_attributes,
                  :available_copies, :total_copies, :bnumber, :set_type, :contents, :last_book_change)
  end

end
