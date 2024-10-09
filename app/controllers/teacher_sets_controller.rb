# frozen_string_literal: true

class TeacherSetsController < ApplicationController
  include TeacherSetsEsHelper
  include MlnException
  include MlnResponse
  include MlnHelper

  #before_action :redirect_to_angular, only: [:index, :show] unless ENV['RAILS_ENV'] == 'test'

  ##
  # GET /teacher_sets.json
  # Called on loading the teacher set list page and when the user selects
  # a facet to filter by.
  def index
    if storable_location?
      store_user_location!
    end
    LogWrapper.log('INFO', {'message' => "Calling elastic search to get teacher-sets",
                            'method' => 'app/controllers/teacher_sets_controller.rb.index'})

    # Get teachersets and facets from elastic search
    teacher_sets, @facets, total_count = ElasticSearch.new.get_teacher_sets_from_es(params)
    @teacher_sets = teacher_sets_from_elastic_search_doc(teacher_sets)

    reset_page_number = ""
    if !@teacher_sets.present? && params["page"]
      params["page"] = "1"
      reset_page_number = "1"
      teacher_sets, @facets, total_count = ElasticSearch.new.get_teacher_sets_from_es(params)
      @teacher_sets = teacher_sets_from_elastic_search_doc(teacher_sets)
    end

    # Determine what facets are selected based on query string
    @facets.each do |f|
      f[:items].each do |v|
        k = f[:label].underscore
        v[:selected] = params.keys.include?(k) && params[k].include?(v[:value].to_s)
      end
    end

    facets = teacher_set_facets(params, @facets)
    
    subjects_hash = {}

    facets.each do |facet|
      next unless facet[:label] == "subjects" && facet[:items].present?

      facet[:items].each do |item|
        subjects_hash[item[:value]] = item[:label]
      end
    end

    if facets.collect { |i| i[:items] }.flatten.empty?
      custom_facets = input_param_facets(params)
      facets = teacher_set_facets(params, custom_facets)
    end

    # Attach custom :q param to each facet with query params to be applied to that link

    per_page = 10
    total_pages = (total_count / per_page.to_f).ceil

    no_results_found_msg = @teacher_sets.length <= 0 ? "No results found." : ""

    render json: { teacher_sets: @teacher_sets, facets: facets, total_count: total_count, total_pages: total_pages, 
                   no_results_found_msg: no_results_found_msg, tsSubjectsHash: subjects_hash, resetPageNumber: reset_page_number, errrorMessage: "" }
  rescue ElasticsearchException => e
    render json: { errrorMessage: "We are having trouble retrieving Teacher Set data right now. Please try again later", teacher_sets: {}, 
                   facets: {} }
  rescue StandardError => e
    LogWrapper.log('ERROR', {'message' => "Error occured in teacherset controller. Error: #{e.message}, backtrace: #{e.backtrace}", 
                             'method' => 'app/controllers/teacher_sets_controller.rb.index'})
    render json:  { errrorMessage: "We've encountered an error. Please try again later or email help@mylibrarynyc.org for assistance.",
      teacher_sets: {}, facets: {}}
  end

  def input_param_facets(params)
    facets = []
    [
      { :label => 'area of study', :column => 'area_of_study' },
      { :label => 'subjects', :column => 'subjects'},
      { :label => 'language', :column => :primary_language },
      { :label => 'set type', :column => 'set_type' }
    ].each do |config|
      facets_group = {:label => config[:label], :items => []}
      params.each do |key, value|
        next if key != config[:label]

        facets_group[:items] << {
          :value => value.join,
          :label => value.join,
          :count => 0
        }
      end
      facets << facets_group
    end
    facets
  end

  # teacher set facets
  def teacher_set_facets(params, facets)
    facets.each do |f|
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
    facets
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
      books: ts_books,
      teacher_set_notes: @set.teacher_set_notes
    }
  end

  # Gets current user teacherset holds from database.
  def teacher_set_holds
    @set = TeacherSet.find(params[:id])
    @holds = @set.holds_for_user(current_user)
  end

  def teacher_set_data; end

  # TODO: Fix: create currently fails our functional tests.
  def create
    TeacherSet.create(teacherset_params)
  end

  def teacher_set_details; end

  private

  # Strong parameters: protect object creation and allow mass assignment.
  def teacherset_params
    params.permit(:slug, :grade_begin, :grade_end, :availability, :call_number, :description, :details_url, :edition, :id,
                  :isbn, :language, :lexile_begin, :lexile_end, :notes, :physical_description, :primary_language, :publication_date,
                  :publisher, :series, :statement_of_responsibility, :sub_title, :title, :books_attributes,
                  :available_copies, :total_copies, :bnumber, :set_type, :contents, :last_book_change)
  end

end
