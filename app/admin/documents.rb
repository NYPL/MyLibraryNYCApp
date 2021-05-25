# frozen_string_literal: true

ActiveAdmin.register Document do
  menu :priority => 12

  permit_params :file, :event_type, :file_name, :url

  controller do
    def create
      attrs = params[:document]
      @document = Document.new
      @document[:event_type] = attrs[:event_type]
      @document[:file_name] = attrs['file_name']
      # attrs['url'] = Google document url.
      # Eg: url = https://docs.google.com/document/d/DrqT7Iu4U/edit
      @document[:url] = attrs['url']
      # Connet's to google client, retrieves the google document and save's to 'file' column with pdf format.
      @document[:file] = @document.google_document
      if @document.save
        redirect_to admin_document_path(@document)
      else
        render :new
      end
    end

    
    def update
      attrs = params[:document]
      @document = Document.where(id: params[:id]).first
      @document[:event_type] = attrs[:event_type]
      @document[:file_name] = attrs['file_name']
      # attrs['url'] = Google document url
      # Eg: url = https://docs.google.com/document/d/DrqT7Iu4U/edit
      @document[:url] = attrs['url']
      # Connet's to google client, retrieves the google document and save's to 'file' column with pdf format.
      @document[:file] = @document.google_document
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
      f.input :file_name
      f.input :url
    end
    f.actions
  end

   
  show do
    attributes_table do
      row :event_type
      row :file_name
      row :file do |f|
        link_to("Download #{f.file_name}.pdf", download_pdf_admin_documents_path(f))
      end
    end
  end

  # Download document from show page.
  collection_action :download_pdf, method: :get do
    document = Document.find(params['format'])
    send_data(document.file, filename: "#{document.file_name}.pdf", type: "application/pdf")
  end


  controller do
    # Setting up Strong Parameters
    # You must specify permitted_params within your document ActiveAdmin resource which reflects a document's expected params.
    def permitted_params
      params.permit document: [:file, :event_type, :url, :created_at, :updated_at]
    end
  end
end
