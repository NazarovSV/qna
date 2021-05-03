# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def gon_current_user
    gon.push({ current_user_id: current_user&.id })
  end
end
