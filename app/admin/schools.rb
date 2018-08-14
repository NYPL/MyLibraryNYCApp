ActiveAdmin.register School do
  menu :priority => 5
  actions :all, except: [:destroy, :new] #just show

  index do
    column :name
    column :active
    default_actions
  end

  filter :name
  filter :active

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
