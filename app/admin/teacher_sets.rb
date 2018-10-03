ActiveAdmin.register TeacherSet do
  actions :show, :index

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
    [:title, :availability, :created_at, :updated_at].each do |prop|
      column prop
    end
  end

  # This method creates a link that we refer to in _version.html.erb this way: history_admin_teacher_set_path(resource)
  member_action :history do
    @versioned_object = TeacherSet.find(params[:id])
    @versions = PaperTrail::Version.where(item_type: 'TeacherSet', item_id: @versioned_object.id).order('created_at ASC')
    render partial: 'admin/history'
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Details" do
      f.input :title
    end
    f.inputs "Description" do
      f.input :description, :input_html => { :rows=> 3 }
    end
    f.inputs "Call Number" do
      f.input :call_number
    end
    f.inputs do
      f.has_many :books, allow_destroy: false do |cf|
        cf.semantic_errors *cf.object.errors.keys
=begin
        if cf.object.errors[:base].count > 0
          cf.object.errors[:base].each do |e|
            e.matching_api_items.each do |t|
              # f.inline_errors_for :base
              # cf.div 'Title', :type=>:radio
              cf.input :catalog_choices
            end
          end
        end
=end
        if cf.object.errors[:base].count > 0
          coll = cf.object.errors[:base].first.matching_api_items.map do |t|
            label = []
            label << t['format']['name'] + ': ' unless t['format'].nil? || t['format']['name'].nil?
            label << t['title'] if t['title']
            label << 'by ' + t['authors'].map { |a| a['name'] }.join('; ') unless t['authors'].nil? || t['authors'].empty?
            label << ' (isbn ' + t['isbns'].first + ')' unless t['isbns'].nil?
            label = label.join ' '
            label = label.truncate 80
            biblio_id = t['id']
            [label, biblio_id]
          end
          coll << ['None of these', '']
          cf.input :catalog_choice, :label => 'Please Select Item', :as => :radio, :collection => coll, :input_html => {:data => {:titles => cf.object.errors[:base].first.matching_api_items}}
        end

        if !cf.object.id.nil?
          cf.input :title, :input_html => {:disabled => true}
          cf.input :_destroy, :as => :boolean, :label => "Delete?"

        else
          cf.input :title
          cf.input :statement_of_responsibility, :label => 'Author Last Name', :input_html => { :rows=> 3 }
          cf.input :isbn, :label => 'ISBN (if known)'
        end
        cf.form_buffers.last
      end
    end
    f.actions
  end

  # The proc below sets the page title to title of the version if there is a version specified in the parameters
  show title: Proc.new{
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

    h2 "Availability: #{teacher_set.availability}"
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
    end

    panel 'Holds' do
      if teacher_set.holds.count == 0
        div 'No holds have been placed for this teacher teacher set.'
      else
        table_for teacher_set.holds do
          column 'Status ' do |hold| link_to hold.status, admin_hold_path(hold) end
          column 'Teacher' do |hold|
            if !hold.user.nil?
              link_to hold.user.email, admin_hold_path(hold)
            else
              "Missing user data"
            end
          end
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
