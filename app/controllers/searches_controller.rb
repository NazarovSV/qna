class SearchesController < ApplicationController
  skip_authorization_check

  def index
    return redirect_to :root, alert: 'Request is empty' unless params['request'].present?
    return redirect_to :root, alert: 'Unknown type' unless params['type'].present? || Search::TYPES.include?(params['type'])

    @result = Search.call(request: params['request'], type: params['type'])
    render :index
  end

  def query_params
    params.permit(:request, :type)
  end
end
