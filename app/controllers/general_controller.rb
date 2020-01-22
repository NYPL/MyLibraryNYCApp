# frozen_string_literal: true

class GeneralController < ApplicationController
  def participating_schools
    render partial: 'layouts/participating_schools'
  end
end
