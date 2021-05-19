class LinksController < ApplicationController
  before_action :authenticate_user!
  expose :link

  authorize_resource

  def destroy
    authorize! :destroy, link
    link.destroy# if current_user.author?(link.linkable)
  end
end
