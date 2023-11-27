# frozen_string_literal: true

ActiveAdmin.register User do
  menu :priority => 6
  actions :all

  before_create do |user|
    user.send_request_to_patron_creator_service if user.valid? # if not valid, errors will show on the form
  end

  csv do
    column :id
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :created_at
    column :updated_at
    column :barcode
    column :first_name
    column :last_name
    column :alt_email
    column :alt_barcodes
    column(:school_name) { |user| user.school.present? ? user.school.name : '' }
    column(:school_borough) { |user| user.school.present? ? user.school.borough : ''}
    column(:school_code) { |user| user.school.present? ? user.school.code : ''}
  end

  index do
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    actions
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
      f.input :alt_email, label: raw('Preferred Email')

      if f.object.new_record?
        f.input :barcode, label: raw('Barcode<br>(leave blank to auto-assign)')
      else
        f.input :barcode
      end
    end
    f.actions
  end

  show title: proc{|user| user.name(true) } do |user|

    attributes_table do
      row :contact_email do
        user.contact_email
      end
      row :school do
        if user.school.nil?
          'No school selected'
        else
          link_to "#{user.school.code}: #{user.school.full_name(' / ')}", admin_school_path(user.school)
        end
      end
      row :doe_email do user.email end

      [:barcode, :alt_barcodes, :first_name, :last_name].each do |prop|
        row prop
      end

      row "Status" do |user|
        user.status.capitalize
      end

      [:updated_at, :current_sign_in_at, :last_sign_in_at ].each do |prop|
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
            if h.teacher_set.nil?
              "This teacher set no longer exists."
            else
              link_to h.teacher_set.title, admin_hold_path(h)
            end
          end
          column 'Quantity' do |h| h.quantity end
          column 'Date Required' do |h| link_to h.date_required, admin_hold_path(h) end
          column 'Created' do |h| h.created_at end
        end
      end
    end

  end

  controller do
    def edit # the edit page title has to be handled this way, source: https://github.com/activeadmin/activeadmin/wiki/Set-page-title
      @page_title = resource.name(true)
    end    
    
    # Setting up Strong Parameters
    # You must specify permitted_params within your users ActiveAdmin resource which reflects a users's expected params.
    def permitted_params
      params.permit user: [:email, :password, :password_confirmation, :remember_me, :barcode, :alt_barcodes, :first_name, 
                           :last_name, :alt_email, :school_id]
    end
  end
end
