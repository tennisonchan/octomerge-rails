class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  after_action :allow_iframe
  before_action :authenticate_user!

private

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end
end
