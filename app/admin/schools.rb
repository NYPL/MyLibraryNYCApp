# frozen_string_literal: true

ActiveAdmin.register School do

  menu :priority => 5
  sidebar :versions, :partial => "admin/version", :only => :show

  controller do
    def create
      PaperTrail.enabled = false
      super
      PaperTrail.enabled = true
    end
  end

  actions :all, except: [:destroy, :new] #just show

  filter :name
  filter :active

  index do
    column :name
    column(:active, sortable: :active) do |school|
      render(partial: 'schools/activation_links_container', locals: { school: school, action: 'index' })
    end
    actions
  end

  # This method creates a link that we refer to in _version.html.erb this way: history_admin_school_path(resource)
  member_action :history do
    @versioned_object = School.find(params[:id])
    @versions = PaperTrail::Version.where(item_type: 'School', item_id: @versioned_object.id).order('created_at ASC')
    render partial: 'admin/history'
  end

  member_action :activate, method: :put do
    school = School.find(params[:id])
    school.active = true
    school.save
    if request.format == :html
      redirect_to admin_school_path(school)
    else
      render js: "activateSchool(#{school.id}, true);"
    end
  end

  member_action :inactivate, method: :put do
    school = School.find(params[:id])
    school.active = false
    school.save
    if request.format == :html
      redirect_to admin_school_path(school)
    else
      render js: "activateSchool(#{school.id}, false);"
    end
  end

  show name: 
    proc {
      school = School.includes(versions: :item).find(params[:id])
      school_version = school.versions[(params[:version].to_i - 1).to_i].reify
      # if there's a bug with turning the paper trail into an object (with reify) then display the school instead of a school version
      school_version = (school_version || school)
      school_version.name
    } do |school|

    return if params[:version] == '0'

    # choose which version's data to display
    if params[:version]
      school_with_versions = School.includes(versions: :item).find(params[:id])
      school_with_version = school_with_versions.versions[(params[:version].to_i - 1).to_i].reify
    else
      school_with_version = school
    end

    attributes_table do
      row 'Name' do 
        school_with_version.name 
      end
      row 'Code' do 
        school_with_version.code 
      end
      row 'Borough' do 
        school_with_version.borough 
      end
    end
  end

  controller do
    #Setting up Strong Parameters
    #You must specify permitted_params within your users ActiveAdmin resource which reflects a users's expected params.
    def permitted_params
      params.permit school: [:name, :code, :active, :address_line_1, :address_line_2, :state, :postal_code, :phone_number, :borough]
    end
  end

end
