# frozen_string_literal: true

ActiveAdmin.register Faq do
  menu :priority => 12
  config.sort_order = 'position_asc'
  permit_params :questions, :answers, :id


  controller do
    def create
      PaperTrail.enabled = false
      super
      PaperTrail.enabled = true
    end
  end

  reorderable
  # Reorderable Index Table
  index as: :reorderable_table do
    column :question
    column :answer
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
    f.inputs "Create Frequently Asked Questions" do
      f.input :question
      f.input :answer
    end
    f.actions
  end
  
  show do |_faq|
    attributes_table do
      row :question
      row :answer
    end
  end
  

  controller do
    # Setting up Strong Parameters
    # You must specify permitted_params within your faq ActiveAdmin resource which reflects a faq's expected params.
    def permitted_params
      params.permit faq: [:id, :question, :answer, :position, :order]
    end
  end
end
