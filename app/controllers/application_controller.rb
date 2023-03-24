class ApplicationController < ActionController::API
  private def page
    params[:page] || 1
  end

  private def per_page
    params[:per_page] || 10
  end
end
