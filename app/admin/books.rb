ActiveAdmin.register Book do

  menu :priority => 4

  index do 
    default_actions
    column :cover_uri do |book|
      image_tag book.image_uri :small
    end
    [:title, :statement_of_responsibility, :call_number].each do |prop|
      column prop
    end
  end

  show do |book|

    attributes_table do
      [:title, :sub_title, :format, :publication_date, :isbn, :primary_language, :call_number, :description, :physical_description, :notes, :statement_of_responsibility, :created_at, :updated_at].each do |prop|
        row prop
      end
    end

    h2 'Teacher Sets'
    if book.teacher_sets.size > 0
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
