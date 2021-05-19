# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def gon_current_user
    gon.push({ current_user_id: current_user&.id })
  end

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    respond_to do |format|
      format.html { redirect_to root_path, alert: exception.message }
      format.js { render status: :forbidden }
      format.json { render json: exception.message, status: :forbidden }
    end
  end

  check_authorization unless: :devise_controller?
end
