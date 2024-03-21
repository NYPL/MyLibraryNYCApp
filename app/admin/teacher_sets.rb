# frozen_string_literal: true

ActiveAdmin.register TeacherSet do
  # The line below was causing an error on the teacher set index page.
  # Even after we remove it, we can still search by teacher sets, so it should be removed.
  # All default filters remain in the sidebar when you use this syntax to remove one filter.
  remove_filter :subject_teacher_sets

  # To make page loading faster and smoother, we'll remove unnecessary filters.
  remove_filter :versions
  remove_filter :teacher_set_notes
  remove_filter :holds
  remove_filter :details_url
  remove_filter :edition
  remove_filter :publication_date
  remove_filter :statement_of_responsibility
  remove_filter :physical_description
  remove_filter :contents
  remove_filter :teacher_set_books
  remove_filter :books

  # Once we start specifying particular formats for the filters,
  # we are obliged to explicitly name all the filters we want to use.
  filter :bnumber
  filter :call_number
  filter :isbn

  filter :title
  filter :sub_title
  filter :description

  filter :books_title, as: :string
  filter :subjects_title, as: :string
  filter :area_of_study

  filter :grade_begin
  filter :grade_end
  filter :lexile_begin
  filter :lexile_end

  filter :availability
  filter :available_copies
  filter :total_copies

  filter :publisher
  filter :series
  filter :language
  filter :primary_language

  filter :created_at
  filter :updated_at
  filter :last_book_change



  actions :index, :show, :update

  menu :priority => 3
  sidebar :versions, :partial => "admin/version", :only => :show

  controller do
    def create
      # Please refer to the comment about Paper Trail in admin/book.rb.
      PaperTrail.enabled = false
      super
      PaperTrail.enabled = true
    end
  end

  index do
    column :title do |teacher_set|
      link_to(teacher_set.title, admin_teacher_set_path(teacher_set))
    end
    column :created_at
    column :updated_at
  end

  # This method creates a link that we refer to in _version.html.erb this way: history_admin_teacher_set_path(resource)
  member_action :history do
    @versioned_object = TeacherSet.find(params[:id])
    @versions = PaperTrail::Version.where(item_type: 'TeacherSet', item_id: @versioned_object.id).order('created_at ASC')
    render partial: 'admin/history'
  end

  member_action :make_available, method: :put do
    teacher_set = TeacherSet.find(params[:id])
    teacher_set.availability = 'available'
    teacher_set.save
    if request.format == :html
      redirect_to admin_teacher_set_path(teacher_set)
    else
      render js: "makeAvailableTeacherSet(#{teacher_set.id}, true);"
    end
  end

  member_action :make_unavailable, method: :put do
    teacher_set = TeacherSet.find(params[:id])
    teacher_set.availability = 'unavailable'
    teacher_set.save
    if request.format == :html
      redirect_to admin_teacher_set_path(teacher_set)
    else
      render js: "makeAvailableTeacherSet(#{teacher_set.id}, false);"
    end
  end

  form do |f|
    if f.object.errors.present? && f.object.errors.keys.present?
      f.semantic_errors *f.object.errors.keys
    end
    f.inputs do
      f.input :total_copies
      f.input :available_copies
      f.input :availability, label: 'Available'
    end
    f.actions
  end

  # The proc below sets the page title to title of the version if there is a version specified in the parameters
  show title: Proc.new {
    teacher_set_with_versions = TeacherSet.includes(versions: :item).find(params[:id])
    if params[:version]
      # title of a version of the teacher set
      version = teacher_set_with_versions.versions[(params[:version].to_i - 1).to_i].reify
      version.title
    else
      # the current teacher set title
      teacher_set_with_versions.title
    end
  } do |teacher_set|

    return if params[:version] == '0'

    # choose which version's data to display
    if params[:version]
      teacher_set_with_versions = TeacherSet.includes(versions: :item).find(params[:id])
      teacher_set_version = teacher_set_with_versions.versions[(params[:version].to_i - 1).to_i].reify
    else
      teacher_set_version = teacher_set
    end

    attributes_table do
      row 'Biblio page' do link_to(teacher_set_version.details_url, teacher_set_version.details_url, target:'_blank') end
      row 'Call Number' do teacher_set_version.call_number end
      row 'Description' do teacher_set_version.description end
      row 'Edition' do teacher_set_version.edition end
      row 'Publication Date' do teacher_set_version.publication_date end
      row 'Statement of Responsibility' do teacher_set_version.statement_of_responsibility end
      row 'Sub Title' do teacher_set_version.sub_title end
      row 'ISBN' do teacher_set_version.isbn end
      row 'Language' do teacher_set_version.language end
      row 'Physical Description' do teacher_set_version.physical_description end
      row 'Publisher' do teacher_set_version.publisher end
      row 'Series' do teacher_set_version.series end
      row 'Total Copies' do teacher_set_version.total_copies end
      row 'Available Copies' do teacher_set_version.available_copies end
    end

    panel 'Holds' do
      if teacher_set.holds.count == 0
        div 'No holds have been placed for this teacher teacher set.'
      else
        table_for teacher_set.holds do
          column 'Status ' do |hold| link_to hold.status, admin_hold_path(hold) end
          column 'Teacher' do |hold|
            if hold.user.nil?
              "Missing user data"
            else
              link_to hold.user.email, admin_hold_path(hold)
            end
          end
          column 'Quantity' do |hold| hold.quantity end
          column 'Date Required' do |hold| link_to hold.date_required, admin_hold_path(hold) end
          column 'Created' do |hold| hold.created_at end
        end
      end
    end

    if teacher_set.books.count > 0
      panel "Books" do
        table_for teacher_set.books do
          column 'Image' do |book| if book.image_uri.nil? then 'None' else link_to image_tag(book.image_uri(:small)), admin_book_path(book) end end
          column 'Title' do |book| link_to book.title, admin_book_path(book) end
          column 'Author(s)' do |book| link_to book.statement_of_responsibility, admin_book_path(book) end
        end
      end
    end
  end
end
