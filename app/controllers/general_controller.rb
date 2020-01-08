class GeneralController < ApplicationController

  def maintenance_banner
    render partial: 'layouts/maintenance_banner'
  end
end

