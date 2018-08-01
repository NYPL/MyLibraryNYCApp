ActiveAdmin.register HoldChange do
  
  actions :all, except: [:edit, :destroy] #just show
  menu false

  controller do
    # Custom new method
    def new
      @hold_change = HoldChange.new
      @hold_change.hold = Hold.find params[:hold]
      #set any other values you might want to initialize
    end

    def create
      params[:hold_change].merge!({ admin_user_id: current_admin_user.id })
      create!
    end
  end

  sidebar :help do
    div "All hold changes trigger an email to the requester. Use the Note field to add a note to the requester in the email. Click a Prepared Note to add prebaked language to the text field."
  end

  form do |f|
    f.inputs "Status Change" do 
      f.semantic_errors *f.object.errors.keys
      f.input :status, :as => :radio, :collection => [
        ['Pending', 'pending'],
        ['Pending - In Transit Aux', 'transit'],
        ['Pending - Trouble Shooting', 'trouble'],
        ['Pending - Unavailable', 'n_a'],
        ['closed', 'closed'],
        ['cancelled', 'cancelled']]

      f.input :comment, :label => 'Note to Requester', :input_html => { :class => 'message' }
      f.input :hold_id, :as => :hidden # :input_html => { :disabled => true } 
    end
    f.actions
  end
end
