ActiveAdmin.register Book do

  menu :priority => 4
  sidebar :versions, :partial => "admin/version", :only => :show

  controller do
    def create
      # We have books already in the db. Paper Trail does not create initial versions for existing objects,
      # so we do not want to create initial versions for any objects created through the admin interface.
      # The first time we create a Paper Trail version for any object will then be the first time that object is edited
      # (via the admin interface or API).
      PaperTrail.enabled = false
      super
      PaperTrail.enabled = true
    end
  end

  index do
    default_actions
    column :cover_uri do |book|
      image_tag book.image_uri :small
    end
    [:title, :statement_of_responsibility, :call_number].each do |prop|
      column prop
    end
  end

  # This method creates a link that we refer to in _version.html.erb this way: history_admin_book_path(resource)
  member_action :history do
    @versioned_object = Book.find(params[:id])
    @versions = PaperTrail::Version.where(item_type: 'Book', item_id: @versioned_object.id).order('created_at ASC')
    render partial: 'admin/history'
  end

  # The proc below sets the page title to title of the version if there is a version specified in the parameters
  show title: Proc.new{
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
      [:title, :sub_title, :format, :publication_date, :isbn, :primary_language, :call_number, :description, :physical_description, :notes, :statement_of_responsibility, :created_at, :updated_at].each do |prop|
        row prop
      end
    end

    h2 'Teacher Sets'
    if book.teacher_sets.count > 0
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
