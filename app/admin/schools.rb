ActiveAdmin.register School do
  menu :priority => 5
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

  action_item only: :show do
    # Note: commented out to stop schools list crashing after rails upgrade.
    # Not sure this line doesn't need to come back, will need to qa a bit.
    #render(partial: 'schools/activation_links_container', locals: { school: school, action: 'show' })
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

  show do |ad|
    attributes_table do
      [:name].each do |prop|
        row prop
      end
      row :borough do
        ad.borough
      end
      row :code do
        ad.code
      end
    end
  end

end
