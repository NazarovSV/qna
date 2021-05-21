class Api::V1::ProfilesController < Api::V1::BaseController
  skip_authorization_check only: :me

  def me
    render json: current_resource_owner
  end

end