class TeacherSetsController < ApplicationController
  before_filter :redirect_to_angular, only: [:index, :show]

  # GET /teacher_sets.json
  def index
    LogWrapper.log('DEBUG', {'message' => 'index.start', 'method' => 'app/controllers/teacher_sets_controller.rb.index'})

    @teacher_sets = TeacherSet.for_query params
    @facets = TeacherSet.facets_for_query @teacher_sets

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
      :teacher_sets => @teacher_sets,
      :facets => @facets
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

    #Max copies value is configured in elastic beanstalk.
    #Max_copies_requestable is the maximum number of teachersets can request.
    max_copies_requestable = ENV['MAXIMUM_COPIES_REQUESTABLE'] || 5

    if @set.held_by? current_user
      @active_hold = @set.pending_holds_for_user(current_user).first
    end

    #ts_holds_count is the number of holds currently held in the database for this teacher set.
    ts_holds_count = @set.holds_count_for_user(current_user)
    user_has_ordered_max = (ts_holds_count.to_i >= max_copies_requestable.to_i)

    #Teacher set available copies less than configured value, we should show ts available_copies count in teacherset order dropdown.
    max_copies_requestable = [max_copies_requestable.to_i - ts_holds_count.to_i, @set.available_copies.to_i].min

    #Button should be disabled after teacher has ordered maximum.
    allowed_quantities = user_has_ordered_max ? [] : (1..max_copies_requestable.to_i).to_a

    render json: {
      :teacher_set => @set,
      :active_hold => @active_hold,
      :user => current_user,
      :allowed_quantities => allowed_quantities
      # :teacher_set_notes => @set.teacher_set_notes,
      # :books => @set.books
    }, serializer: TeacherSetForUserSerializer, root: "teacher_set"
  end


  # Gets current user teacherset holds from database.
  def teacher_set_holds
    LogWrapper.log('DEBUG', {'message' => 'teacher_set_holds.start', 'method' => 'app/controllers/teacher_sets_controller.rb.teacher_set_holds'})
    @set = TeacherSet.find(params[:id])
    @holds = @set.holds_for_user(current_user)
  end

end
