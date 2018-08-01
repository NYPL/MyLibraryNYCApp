ActiveAdmin.register TeacherSet do

  menu :priority => 3

  index do 
    default_actions
    [:title, :availability, :created_at, :updated_at].each do |prop|
      column prop
    end
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
        if cf.object.errors[:base].size > 0
          cf.object.errors[:base].each do |e|
            e.matching_api_items.each do |t|
              # f.inline_errors_for :base
              # cf.div 'Title', :type=>:radio
              cf.input :catalog_choices
            end
          end
        end
=end
        if cf.object.errors[:base].size > 0
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

  show do |set|
    h2 "Availability: #{set.availability}"
    attributes_table do
      row 'Biblio page' do link_to(set.details_url, set.details_url, target:'_blank') end
      [:call_number, :description, :edition, :publication_date, :statement_of_responsibility, :sub_title, :isbn, :language, :physical_description, :publisher, :series].each do |prop|
        row prop
      end
    end

    panel 'Holds' do
      if set.holds.size == 0
        div 'No holds have been placed for this teacher set.'
      else
        table_for set.holds do
          column 'Status ' do |h| link_to h.status, admin_hold_path(h) end
          column 'Teacher' do |h|
            if !h.user.nil?
              link_to h.user.email, admin_hold_path(h)
            else
              "Missing user data"
            end
          end
          column 'Date Required' do |h| link_to h.date_required, admin_hold_path(h) end
          column 'Created' do |h| h.created_at end
        end
      end
    end

    if teacher_set.books.size > 0
      panel "Books" do 
        table_for teacher_set.books do
          column 'Image' do |b| if b.image_uri.nil? then 'None' else link_to image_tag(b.image_uri(:small)), admin_book_path(b) end end
          column 'Title' do |b| link_to b.title, admin_book_path(b) end
          column 'Author(s)' do |b| link_to b.statement_of_responsibility, admin_book_path(b) end
        end
      end
    end

  end  
end
