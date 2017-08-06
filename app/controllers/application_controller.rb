class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :nilCheck

  def nilCheck(item, key = '')
    if key.empty? then
      item.nil? ? "none" : item
    else
      item.nil? ? "none" : item[key]
    end
  end

end

