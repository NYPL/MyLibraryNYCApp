# frozen_string_literal: true

ActiveAdmin.register Book do

  # To make page loading faster and smoother, we'll remove unnecessary filters.
  remove_filter :versions
  remove_filter :teacher_set_books
  remove_filter :format
  remove_filter :details_url
  remove_filter :notes
  remove_filter :statement_of_responsibility
  remove_filter :cover_uri

  filter :isbn
  filter :call_number

  filter :title
  filter :sub_title
  filter :teacher_sets_title, as: :string

  filter :description
  filter :physical_description

  filter :primary_language

  filter :publication_date
  filter :created_at
  filter :updated_at



  actions :show, :index

  menu :priority => 4
  sidebar :versions, :partial => "admin/version", :only => :show

  index do
    column :cover_uri do |book|
      if book && book.image_uri.present?
        link_to((image_tag book.image_uri :small), admin_book_path(book))
      else
        "No image"
      end
    end
    column :title do |book|
      link_to(book.title, admin_book_path(book))
    end
    column :statement_of_responsibility
    column :call_number
  end

  # This method creates a link that we refer to in _version.html.erb this way: history_admin_book_path(resource)
  member_action :history do
    @versioned_object = Book.find(params[:id])
    @versions = PaperTrail::Version.where(item_type: 'Book', item_id: @versioned_object.id).order('created_at ASC')
    render partial: 'admin/history'
  end

  # The proc below sets the page title to title of the version if there is a version specified in the parameters
  show title: Proc.new {
    book = Book.includes(versions: :item).find(params[:id])
    begin
      book_version = book.versions[(params[:version].to_i - 1).to_i].reify
    rescue
    end
    # if there's a bug with turning the paper trail into an object (with reify) then display the book instead of a book version
    book_version = (book_version || book)
    book_version.title
  } do |book|
    attributes_table do
      [:title, :sub_title, :format, :publication_date, :isbn, :primary_language, :call_number, :description, :physical_description, :notes, 
       :statement_of_responsibility, :created_at, :updated_at].each do |prop|
        row prop
      end
    end

    h2 'Teacher Sets'
    if book.teacher_sets.count.positive?
      table_for book.teacher_sets do
        column 'Title' do |s| link_to s.title, admin_teacher_set_path(s) end
        column 'Availability' do |s| link_to s.availability, admin_teacher_set_path(s) end
      end
    end
  end

  sidebar :Image, :only => :show do
    image_tag book.image_uri :medium
  end

end
