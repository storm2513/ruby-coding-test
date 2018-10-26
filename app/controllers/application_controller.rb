class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound do
    respond_to do |format|
      format.json do
        head :not_found
      end
      format.html { render plain: 'Not Found' }
    end
  end
end
