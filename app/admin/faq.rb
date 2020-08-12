ActiveAdmin.register Faq do
  menu :priority => 12
  config.sort_order = 'position_asc'
  #sidebar :versions, :partial => "admin/version", :only => :show
  permit_params :questions, :answers, :id

  controller do
    def create
      PaperTrail.enabled = false
      super
      PaperTrail.enabled = true
    end
  end

  # config.clear_action_items!
  reorderable
  # Reorderable Index Table
  index as: :reorderable_table do
    column :questions
    column :answers
    column :links do |resource|
      links = ''.html_safe
      if controller.action_methods.include?('show')
        links += link_to I18n.t('active_admin.view'), resource_path(resource), :class => "member_link view_link"
      end
      if controller.action_methods.include?('edit') 
        links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource), :class => "member_link edit_link"
      end
      if controller.action_methods.include?('destroy')
        links += link_to I18n.t('active_admin.delete'), resource_path(resource), :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link"
      end
      links
    end
  end

  form do |f|
    f.inputs "Creare Frequently Asked Questions" do
      f.input :questions
      f.input :answers
    end
    f.actions
  end
  
  show questions: 
    proc {
      faq = Faq.includes(versions: :item).find(params[:id])
      faq_version = faq.versions[(params[:version].to_i - 1).to_i].reify
      # if there's a bug with turning the paper trail into an object (with reify) then display the school instead of a school version
      faq_version = (faq_version || faq)
      faq_version.questions
    } do |faq|

    return if params[:version] == '0'

    # choose which version's data to display
    if params[:version]
      faq_with_versions = faq.includes(versions: :item).find(params[:id])
      faq_with_version = faq_with_versions.versions[(params[:version].to_i - 1).to_i].reify
    else
      faq_with_version = faq
    end

    attributes_table do
      row 'Questions' do 
        faq_with_version.questions 
      end
      row 'Answers' do 
        faq_with_version.answers 
      end
    end
  end

  controller do
    #Setting up Strong Parameters
    #You must specify permitted_params within your faq ActiveAdmin resource which reflects a faq's expected params.
    def permitted_params
      params.permit faq: [:id, :questions, :answers, :position, :order]
    end
  end
end