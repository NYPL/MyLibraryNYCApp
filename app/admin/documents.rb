# frozen_string_literal: true

ActiveAdmin.register Document do
  menu :priority => 12
  permit_params :file, :event_type, :file_name, :file_path

  #actions :index, :show, :new, :create, :update


  controller do
    def create
      attrs = permitted_params[:document]
      @document = Document.new
      @document[:event_type] = attrs[:event_type]

      if attrs[:file].present?
        @document[:file_name] = attrs[:file].original_filename
        @document[:file] = attrs[:file].read
        @document[:file_path] = attrs[:file].tempfile.path
      end
      if @document.save
        redirect_to admin_document_path(@document)
      else
        render :new
      end
    end

    def update
      attrs = permitted_params[:document]
      @document = Document.where(id: params[:id]).first!
      @document[:event_type] = attrs[:event_type]
      @document[:file_path] = File.new(@document.file_path, "w").path
      
      if attrs[:file].present?
        @document[:file_name] = attrs[:file].original_filename
        @document[:file_path] = attrs[:file].tempfile.path
        @document[:file] = attrs[:file].read
      end
      if @document.save
        redirect_to admin_document_path(@document)
      else
        render :edit
      end
    end
  end

  # Reorderable Index Table
  index do
    column :event_type
    column :file_name
    column :created_at
    column :updated_at
    column :links do |resource|
      links = ''.html_safe
      if controller.action_methods.include?('show')
        links += link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
      end
      if controller.action_methods.include?('edit') 
        links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      end
      if controller.action_methods.include?('destroy') 
        links += link_to I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, 
        data: { confirm: 'Are you sure you want to delete this Content?' }, :class => "member_link delete_link"
      end
      links
    end
  end

  form do |f|
    f.inputs "Create MyLibraryNyc Documents" do
      f.input :event_type, collection: Document::EVENTS, include_blank: false
      if !f.object.new_record?
        f.input :file_name, :input_html => { :disabled => true } 
      end
      f.input :file, as: :file
    end
    f.actions
  end

   show do
    attributes_table do
      row :event_type
      row :file_name
    end
  end


  controller do
    # Setting up Strong Parameters
    # You must specify permitted_params within your document ActiveAdmin resource which reflects a document's expected params.
    def permitted_params
      params.permit document: [:file, :event_type, :file_path, :created_at, :updated_at]
    end
  end
end
