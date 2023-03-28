# frozen_string_literal: true

ActiveAdmin.register Hold do

  menu :priority => 2

  # config.clear_action_items!
  actions :all, except: [:edit, :destroy, :new] #just show

  # The hold_changes and the user filters produce very long drop-downs, which are not helpful
  # in their current form, and slow down the page.
  remove_filter :hold_changes
  remove_filter :user

  # Make the teacher set filter appear as a text input field, rather than a select list.
  # Tell ActiveAdmin to search teacher sets on the title attribute.
  filter :teacher_set_title, as: :string

  # Make it easier to specify the status, by listing it as a checkbox, rather than a text input field.
  filter :status, as: :check_boxes, collection: [["new", "new"], ["pending", "pending"], ["cancelled", "cancelled"]]

  filter :created_at
  filter :updated_at
  filter :date_required

  # Refers to the unique hexadecimal key generated by the system, so hold orders could be cancelled from the
  # order confirmation email.  Might not be needed here.
  filter :access_key

  # add a quick filter button to find hold orders that have not been fulfilled or cancelled
  scope :new_holds

  i = 0
  index do
    column "#" do i += 1 end

    actions

    [:status, :teacher_set, :quantity, :created_at, :updated_at].each do |prop|
      column prop
    end

    column 'Call Number', :sortable => :'teacher_sets.call_number' do |h|
      if !h.teacher_set.nil?
        link_to h.teacher_set.call_number, admin_hold_path(h)
      end
    end

    column 'User' do |h|
      if h.user.nil?
        "Missing user data"
      else
        link_to h.user.email, admin_hold_path(h)
      end
    end

    column 'Requester Barcode', :sortable => :'users.barcode' do |h|
      if h.user.nil?
        "Missing user data"
      else
        link_to h.user.barcode, admin_hold_path(h)
      end
    end

  end

  controller do
    def scoped_collection
      # Makes the sorting by associated types work.
      Hold.includes(:user, :teacher_set)
      # can also do:
      #end_of_association_chain.includes(:user, :teacher_set)
    end
  end

  form do |f|
    f.inputs "Edit" do
      f.input :status
    end
    f.actions
  end

  show do |ad|
    h2 "Status: #{ad.status}"
    h3 do link_to 'Change Status', new_admin_hold_change_path(:hold => ad) end

    if ad.hold_changes.count.positive?
      table_for ad.hold_changes.order('created_at DESC') do
        column 'Status ' do |c| link_to c.status, admin_hold_change_path(c) end
        column 'Admin' do |c| link_to c.admin_user.name, admin_hold_change_path(c) unless c.admin_user.nil? end
        column 'Date' do |c| c.created_at end
      end
    end

    attributes_table do
      row :requester do |ad|
        if ad.user.nil?
          "Missing user data"
        else
          link_to ad.user.name(true), admin_user_path(ad.user)
        end
      end
      row :requester_barcode do |ad|
        if ad.user.nil?
          "Missing user data"
        else
          link_to ad.user.barcode, admin_user_path(ad.user)
        end
      end
      row :requester_school do |ad|
        if ad.user.nil?
          "Missing user data"
        else
          link_to "#{ad.user.school.code}: #{ad.user.school.name}", admin_user_path(ad.user)
        end
      end
      row :teacher_set do |ad|
        if ad.teacher_set.nil?
          "Teacher set deleted. Please cancel the hold."
        else
          link_to "#{ad.teacher_set.call_number}: #{ad.teacher_set.title}", admin_teacher_set_path(ad.teacher_set)
        end
      end

      if ad.teacher_set.present?
        row :quantity
      end

      [:date_required, :created_at, :updated_at].each do |prop|
        row prop
      end
    end

    if ad.teacher_set.present?
      panel "Books" do
        if ad.teacher_set.books.count.positive?
          table_for ad.teacher_set.books do
            column 'Image' do |b| if b.image_uri.nil? then 'None' else link_to image_tag(b.image_uri(:small)), admin_book_path(b) end end
            column 'Title' do |b| link_to b.title, admin_book_path(b) end
            column 'Author(s)' do |b| link_to b.statement_of_responsibility, admin_book_path(b) end
          end
        end
      end
    end

  end

  member_action :close, :method => :put do
    hold = Hold.find(params[:id])
    if hold.present? && hold.user.present?
      hold.close!(hold.user.first_name) 
      redirect_to action: :show, notice: "Hold closed!"
    end
  end

  i = 0
  csv do
    column "#" do i += 1 end
    [:status, :created_at, :updated_at].each do |prop|
      column prop
    end

    column 'Set' do |h|
      if h.teacher_set.present?
        h.teacher_set.title
      else
        "This teacher set no longer exist."
      end
    end

    column 'Call Number' do |h|
      if h.teacher_set.present?
        h.teacher_set.call_number
      end
    end

    column 'User' do |h|
      if h.user.nil?
        "Missing user data"
      else
        h.user.email
      end
    end

    column 'Requester Barcode' do |h|
      if h.user.nil?
        "Missing user data"
      else
        h.user.barcode
      end
    end
  end

  controller do
    #Setting up Strong Parameters
    #You must specify permitted_params within your users ActiveAdmin resource which reflects a users's expected params.
    def permitted_params
      params.permit hold: [:date_required]
    end
  end

end
