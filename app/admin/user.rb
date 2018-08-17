ActiveAdmin.register User do
  menu :priority => 6
  actions :all

  index do
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  filter :email
  filter :last_name
  filter :school
  filter :barcode

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "User Details" do
      f.input :school
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :barcode
      f.input :alt_email
      f.input :alt_barcodes
    end
    f.actions
  end

  show do |ad|

    attributes_table do
      row :contact_email do
        link_to ad.contact_email, ad.contact_email
      end
      row :school do
        if ad.school.nil?
          'No school selected'
        else
          link_to "#{ad.school.code}: #{ad.school.full_name(' / ')}", admin_school_path(ad.school)
        end
      end
      row :doe_email do ad.email end
      [:barcode, :alt_barcodes, :first_name, :last_name, :updated_at, :current_sign_in_at, :last_sign_in_at].each do |prop|
        row prop
      end
    end

    panel 'Holds' do
      if user.holds.count == 0
        div 'No holds'
      else
        table_for user.holds do
          column 'Status ' do |h| link_to h.status, admin_hold_path(h) end
          column 'Set' do |h|
            if !h.teacher_set.nil?
              link_to h.teacher_set.title, admin_hold_path(h)
            else
              "This teacher set no longer exists."
            end
          end
          column 'Date Required' do |h| link_to h.date_required, admin_hold_path(h) end
          column 'Created' do |h| h.created_at end
        end
      end
    end

  end

end
