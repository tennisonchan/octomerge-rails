class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  after_action :allow_iframe
  before_action :store_params
  before_action :authenticate_user!

private

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

  def store_params
    @iframe = params[:iframe] === '1'
  end
end
