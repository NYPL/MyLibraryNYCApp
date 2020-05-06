# frozen_string_literal: true
class TeacherSetsController < ApplicationController

  before_action :redirect_to_angular, only: [:index, :show] unless ENV['RAILS_ENV'] == 'test'

  ##
  # GET /teacher_sets.json
  # Called on loading the teacher set list page and when the user selects
  # a facet to filter by.

  def create_ts_object_from_json(json)
    arr = []
    if json[:hits].present? && json[:hits].present?
      json[:hits].each do |ts|
        teacher_set = TeacherSet.new
        next if ts["_source"]['mappings'].present?
        teacher_set.title = ts["_source"]['title']
        teacher_set.description = ts["_source"]['description']
        teacher_set.contents = ts["_source"]['contents']
        teacher_set.grade_begin = ts["_source"]['grade_begin']
        teacher_set.grade_end = ts["_source"]['grade_end']
        teacher_set.language = ts["_source"]['language']
        teacher_set.id = ts["_source"]['id']
        teacher_set.details_url = ts["_source"]['details_url']
        teacher_set.availability = ts["_source"]['availability']
        teacher_set.total_copies = ts["_source"]['total_copies']
        teacher_set.call_number = ts["_source"]['call_number']
        teacher_set.language = ts["_source"]['language']
        teacher_set.physical_description = ts["_source"]['physical_description']
        teacher_set.primary_language = ts["_source"]['primary_language']
        teacher_set.created_at = ts["_source"]['created_at']
        teacher_set.updated_at = ts["_source"]['updated_at']
        teacher_set.available_copies = ts["_source"]['available_copies']
        teacher_set.bnumber = ts["_source"]['bnumber']
        teacher_set.set_type = ts["_source"]['set_type']
        arr << teacher_set 
      end
    end
    arr
  end

  def index
    LogWrapper.log('DEBUG', {'message' => 'index.start', 'method' => 'app/controllers/teacher_sets_controller.rb.index'})
  begin

    if true#MlnConfigurationController.new.feature_flag_config('ts.data.from.es.enabled')
      teacher_sets = ElasticSearch.new.get_teacher_sets_from_es(params)
      @teacher_sets = create_ts_object_from_json(teacher_sets)
    else
      @teacher_sets = TeacherSet.for_query params
    end
    @facets = TeacherSet.facets_for_query TeacherSet.for_query params
    # Determine what facets are selected based on query string
    @facets.each do |f|
      f[:items].each do |v|
        k = f[:label].underscore
        v[:selected] = params.keys.include?(k) && params[k].include?(v[:value].to_s)
      end
    end

    # Attach custom :q param to each facet with query params to be applied to that link
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
    render json: {
      teacher_sets: @teacher_sets,
      facets: @facets
    }, serializer: SearchSerializer, include_books: false, include_contents: false
  end
  rescue Exception => e
    LogWrapper.log('ERROR', {'message' => e.message, 'method' => 'app/controllers/teacher_sets_controller.rb.index'})
    render json: {
      errors: {error_message: "We've encountered an error. Please try again later or email help@mylibrarynyc.org for assistance."},
      teacher_sets: {},
      facets: {}
    }, serializer: SearchSerializer, include_books: false, include_contents: false
  end


  # GET /teacher_sets/1.json
  def show
    LogWrapper.log('DEBUG', {'message' => 'show.start', 'method' => 'app/controllers/teacher_sets_controller.rb.show'})

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
    LogWrapper.log('DEBUG', {'message' => 'teacher_set_holds.start', 'method' => 'app/controllers/teacher_sets_controller.rb.teacher_set_holds'})
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
