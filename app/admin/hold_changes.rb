# frozen_string_literal: true

ActiveAdmin.register HoldChange do
  
  actions :all, except: [:edit, :destroy] #just show
  menu false

  controller do
    # Custom new method
    def new
      @hold_change = HoldChange.new
      @hold_change.hold = Hold.find params[:hold]
      @page_title = "New Hold Change for #{@hold_change.hold.teacher_set.title}"
      #set any other values you might want to initialize
    end
    
    def create
      params[:hold_change].merge!({ admin_user_id: current_admin_user.id })
      # Update teacher-set available copies while cancel or closed the hold.
      if ['cancelled', 'closed'].include?(params[:hold_change]['status'])
        hold = Hold.find(params[:hold_change]['hold_id'])
        teacher_set = TeacherSet.where(id: hold.teacher_set_id).first
        if teacher_set.present?
          hold.teacher_set.available_copies = hold.teacher_set.available_copies.to_i + teacher_set.holds_count_for_user(current_user, hold.id).to_i
          hold.teacher_set.save!
        end
      end
      create!
    end
  end

  sidebar :help do
    div "All hold changes trigger an email to the requester. Use the Note field to add a note to the requester in the email. \
         Click a Prepared Note to add prebaked language to the text field."
  end

  form do |f|
    f.inputs "Status Change" do
      if f.object.errors.present? && f.object.errors.keys.present?
        f.semantic_errors *f.object.errors.keys
      end
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
    f.actions do
      f.action :submit
      f.action :cancel, :label => 'Cancel'
    end
  end

  controller do
    #Setting up Strong Parameters
    #You must specify permitted_params within your users ActiveAdmin resource which reflects a hold_change's expected params.
    def permitted_params
      params.permit hold_change: [:status, :comment, :hold_id, :admin_user_id]
    end
  end
end
