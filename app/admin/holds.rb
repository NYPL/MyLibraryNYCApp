ActiveAdmin.register Hold do

  menu :priority => 2

  # config.clear_action_items!
  actions :all, except: [:edit, :destroy, :new] #just show

  i = 0
  index do
    column "#" do i += 1 end
    default_actions
    [:status, :teacher_set, :created_at, :updated_at].each do |prop|
      column prop
    end

    column 'Call Number', sortable: :call_number do |h|
      if !h.teacher_set.nil?
        link_to h.teacher_set.call_number, admin_hold_path(h)
      end
    end

    column 'User' do |h|
      if !h.user.nil?
        link_to h.user.email, admin_hold_path(h)
      else
        "Missing user data"
      end
    end

    column 'Requester Barcode', sortable: :barcode do |h|
      if !h.user.nil?
        link_to h.user.barcode, admin_hold_path(h)
      else
        "Missing user data"
      end
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

    if ad.hold_changes.size > 0
      table_for ad.hold_changes.order('created_at DESC') do 
        column 'Status ' do |c| link_to c.status, admin_hold_change_path(c) end
        column 'Admin' do |c| link_to c.admin_user.name, admin_hold_change_path(c) unless c.admin_user.nil? end
        column 'Date' do |c| c.created_at end
      end
    end
   
    attributes_table do
      row :requester do |ad|
        if !ad.user.nil?
          link_to ad.user.name(true), admin_user_path(ad.user)
        else
          "Missing user data"
        end
      end
      row :requester_barcode do |ad|
        if !ad.user.nil?
          link_to ad.user.barcode, admin_user_path(ad.user)
        else
          "Missing user data"
        end
      end
      row :requester_school do |ad|
        if !ad.user.nil?
          link_to "#{ad.user.school.code}: #{ad.user.school.name}", admin_user_path(ad.user)
        else
          "Missing user data"
        end
      end
      row :teacher_set do |ad|
        if !ad.teacher_set.nil?
          link_to "#{ad.teacher_set.call_number}: #{ad.teacher_set.title}", admin_teacher_set_path(ad.teacher_set)
        else
          "Teacher set deleted. Please cancel the hold."
        end
      end
      [:date_required, :created_at, :updated_at].each do |prop|
        row prop
      end
    end

    if ad.teacher_set.books.size > 0
      panel "Books" do 
        table_for ad.teacher_set.books do
          column 'Image' do |b| if b.image_uri.nil? then 'None' else link_to image_tag(b.image_uri(:small)), admin_book_path(b) end end
          column 'Title' do |b| link_to b.title, admin_book_path(b) end
          column 'Author(s)' do |b| link_to b.statement_of_responsibility, admin_book_path(b) end
        end
      end
    end
  end  

  member_action :close, :method => :put do
    hold = Hold.find(params[:id])
    user.close!
    redirect_to action: :show, notice: "Hold closed!"
  end

  i = 0
  csv do
    column "#" do i += 1 end
    [:status, :created_at, :updated_at].each do |prop|
      column prop
    end

    column 'Set' do |h|
      if !h.teacher_set.nil?
        h.teacher_set.title
      else
        "This teacher set no longer exist."
      end
    end

    column 'Call Number' do |h|
      if !h.teacher_set.nil?
        h.teacher_set.call_number
      end
    end

    column 'User' do |h|
      if !h.user.nil?
        h.user.email
      else
        "Missing user data"
      end
    end

    column 'Requester Barcode' do |h|
      if !h.user.nil?
        h.user.barcode
      else
        "Missing user data"
      end
    end
  end

end
