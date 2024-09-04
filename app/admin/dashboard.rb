# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    order_param = params[:order]
    order = nil
    pending_order = nil
    if !order_param.nil? && order_param[0] == 'p'
      pending_order = case(order_param)
      when 'p_school_desc'
        'users.home_library DESC'
      when 'p_school_asc'
        'users.home_library ASC'
      when 'p_user_desc'
        'users.email DESC'
      when 'p_user_asc'
        'users.email ASC'
      when 'p_barcode_asc'
        'users.barcode ASC'
      when 'p_barcode_desc'
        'users.barcode DESC'
      when 'p_call_number_asc'
        'teacher_sets.call_number ASC'
      when 'p_call_number_desc'
        'teacher_sets.call_number DESC'
      when 'p_set_asc'
        'teacher_sets.title ASC'
      when 'p_set_desc'
        'teacher_sets.title DESC'
      when 'p_created_at_asc'
        'created_at ASC'
      when 'p_created_at_desc'
        'created_at DESC'
      when 'p_quantity_asc'
        'quantity ASC'
      when 'p_quantity_desc'
        'quantity DESC'
      else
        nil
      end
    elsif !order_param.nil?
      order = case(order_param)
      when 'school_desc'
        'users.home_library DESC'
      when 'school_asc'
        'users.home_library ASC'
      when 'user_desc'
        'users.email DESC'
      when 'user_asc'
        'users.email ASC'
      when 'barcode_asc'
        'users.barcode ASC'
      when 'barcode_desc'
        'users.barcode DESC'
      when 'call_number_asc'
        'teacher_sets.call_number ASC'
      when 'call_number_desc'
        'teacher_sets.call_number DESC'
      when 'set_asc'
        'teacher_sets.title ASC'
      when 'set_desc'
        'teacher_sets.title DESC'
      when 'created_at_asc'
        'created_at ASC'
      when 'created_at_desc'
        'created_at DESC'
      when 'quantity_asc'
        'quantity ASC'
      when 'quantity_desc'
        'quantity DESC'
      else
        nil
      end
    end

    if (order.nil?)
      holds = Hold.unseen
    elsif order_param == 'call_number_desc' or
        order_param == 'call_number_asc' or
        order_param == 'set_desc' or
        order_param == 'set_asc'
      holds = Hold.unseen.joins('JOIN teacher_sets on teacher_sets.id = holds.teacher_set_id').order(order)
    else
      holds = Hold.unseen.joins('JOIN users on users.id = holds.user_id').order(order)
    end
    if (pending_order.nil?)
      pending_holds = Hold.pending
    elsif order_param == 'p_call_number_desc' or
        order_param == 'p_call_number_asc' or
        order_param == 'p_set_desc' or
        order_param == 'p_set_asc'
      pending_holds = Hold.pending.joins('JOIN teacher_sets on teacher_sets.id = holds.teacher_set_id').order(pending_order)
    else
      pending_holds = Hold.pending.joins('JOIN users on users.id = holds.user_id').order(pending_order)
    end

    pending_transit = Hold.transit
    pending_trouble = Hold.trouble
    pending_unavailable = Hold.unavailable

    columns do
      column do
        h2 "New"
        if Hold.unseen.count == 0
          div 'No new holds'
        else
          i = 0
          table_for holds, {sortable: 'new', :class => 'index_table'} do
            column "#" do
              i += 1
            end

            column 'Set', sortable: :set do |h|
              if h.teacher_set.nil?
                "This teacher set no longer exists."
              else
                link_to h.teacher_set.title, admin_hold_path(h)
              end
            end

            column 'Call Number', sortable: :call_number do |h|
              if !h.teacher_set.nil?
                link_to h.teacher_set.call_number, admin_hold_path(h)
              end
            end

            column 'Quantity', sortable: :quantity do |h|
              if !h.quantity.nil?
                h.quantity
              end
            end

            column 'User', sortable: :user do |h|
              if h.user.nil?
                "Missing user data"
              else
                link_to h.user.email, admin_hold_path(h)
              end
            end

            column 'Requester Barcode', sortable: :barcode do |h|
              if h.user.nil?
                "Missing user data"
              else
                link_to h.user.barcode, admin_hold_path(h)
              end
            end

            column 'Date', sortable: :created_at do |h|
              if h.nil?
                "Missing hold data"
              else
                link_to h.created_at.strftime("%m/%d/%Y"), admin_hold_path(h)
              end
            end

          end
        end
      end
    end

    columns do
      column do
        h2 "Pending"
        if Hold.pending.count == 0
          div 'No Pending - Trouble holds'
        else
          i = 0
          table_for pending_holds, {sortable: 'pending', :class => 'index_table'} do
            column "#" do i += 1 end
            column 'Set', sortable: :p_set do |h| 
              if h.teacher_set.present?
                link_to h.teacher_set.title, admin_hold_path(h)
              else
                "This teacher set no longer exists."
              end
            end
            column 'Call Number', sortable: :p_call_number do |h| 
              link_to h.teacher_set.call_number, admin_hold_path(h) if h.teacher_set.present?
            end
            column 'Quantity', sortable: :quantity do |h|
              if !h.quantity.nil?
                h.quantity
              end
            end
            column 'User', sortable: :p_user do |h|
              if h.user.nil?
                "Missing user data"
              else
                link_to h.user.email, admin_hold_path(h)
              end
            end
            column 'Requester Barcode', sortable: :p_barcode do |h| 
              if h.user.nil?
                "Missing user data"
              else
                link_to h.user.barcode, admin_hold_path(h)
              end
            end
            column 'Date', sortable: :p_created_at do |h|
              if h.nil?
                "Missing hold data"
              else
                link_to h.created_at.strftime("%m/%d/%Y"), admin_hold_path(h)
              end
            end
          end
        end
      end
    end

    columns do
      column do
        h2 "Pending - In Transit Aux"
        if Hold.transit.count == 0
          div 'No Pending - In Transit Aux holds'
        else
          i = 0
          table_for pending_transit, {sortable: 'pending', :class => 'index_table'} do
            column "#" do i += 1 end
            column 'Set', sortable: :p_set do |h|
              if h.teacher_set.present?
                link_to h.teacher_set.title, admin_hold_path(h)
              else
                "This teacher set no longer exists."
              end
            end
            column 'Call Number', sortable: :p_call_number do |h|
              link_to h.teacher_set.call_number, admin_hold_path(h) if h.teacher_set.present?
            end
            column 'Quantity', sortable: :quantity do |h|
              if !h.quantity.nil?
                h.quantity
              end
            end
            column 'User', sortable: :p_user do |h|
              if h.user.nil?
                "Missing user data"
              else
                link_to h.user.email, admin_hold_path(h)
              end
            end
            column 'Requester Barcode', sortable: :p_barcode do |h| 
              if h.user.nil?
                "Missing user data"
              else
                link_to h.user.barcode, admin_hold_path(h)
              end
            end
            column 'Date', sortable: :p_created_at do |h|
              if h.nil?
                "Missing hold data"
              else
                link_to h.created_at.strftime("%m/%d/%Y"), admin_hold_path(h)
              end
            end
          end
        end
      end
    end

    columns do
      column do
        h2 "Pending - Trouble"
        if Hold.trouble.count == 0
          div 'No Pending - Trouble holds'
        else
          i = 0
          table_for pending_trouble, {sortable: 'pending', :class => 'index_table'} do
            column "#" do i += 1 end
            column 'Set', sortable: :p_set do |h|
              if h.teacher_set.present?
                link_to h.teacher_set.title, admin_hold_path(h)
              else
                "This teacher set no longer exists."
              end
            end
            column 'Call Number', sortable: :p_call_number do |h|
              link_to h.teacher_set.call_number, admin_hold_path(h) if h.teacher_set.present?
            end
            column 'Quantity', sortable: :quantity do |h|
              if !h.quantity.nil?
                h.quantity
              end
            end
            column 'User', sortable: :p_user do |h|
              if h.user.nil?
                "Missing user data"
              else 
                link_to h.user.email, admin_hold_path(h)
              end
            end
            column 'Requester Barcode', sortable: :p_barcode do |h| 
              if h.user.nil?
                "Missing user data"
              else
                link_to h.user.barcode, admin_hold_path(h)
              end
            end
            column 'Date', sortable: :p_created_at do |h|
              if h.nil?
                "Missing hold data"
              else
                link_to h.created_at.strftime("%m/%d/%Y"), admin_hold_path(h)
              end
            end
          end
        end
      end
    end

    columns do
      column do
        h2 "Pending - Unavailable"
        if Hold.unavailable.count == 0
          div 'No Pending - Unavailable holds'
        else
          i = 0
          table_for pending_unavailable, {sortable: 'pending', :class => 'index_table'} do
            column "#" do i += 1 end
            column 'Set', sortable: :p_set do |h|
              if h.teacher_set.present?
                link_to h.teacher_set.title, admin_hold_path(h)
              else
                "This teacher set no longer exists."
              end
            end
            column 'Call Number', sortable: :p_call_number do |h|
              link_to h.teacher_set.call_number, admin_hold_path(h) if h.teacher_set.present?
            end
            column 'Quantity', sortable: :quantity do |h|
              if !h.quantity.nil?
                h.quantity
              end
            end
            column 'User', sortable: :p_user do |h| 
              if h.user.nil?
                "Missing user data"
              else
                link_to h.user.email, admin_hold_path(h)
              end
            end
            column 'Requester Barcode', sortable: :p_barcode do |h| 
              if h.user.nil?
                "Missing user data"
              else
                link_to h.user.barcode, admin_hold_path(h)
              end
            end
            column 'Date', sortable: :p_created_at do |h|
              if h.nil?
                "Missing hold data"
              else
                link_to h.created_at.strftime("%m/%d/%Y"), admin_hold_path(h)
              end
            end
          end
        end
      end

    end

  end # content
end
