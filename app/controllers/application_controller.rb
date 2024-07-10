class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: 'Brak uprawnień do wykonania tej akcji.'
  end
end
