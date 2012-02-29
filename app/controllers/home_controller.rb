class HomeController < ApplicationController

  def index
    redirect_to "/#{I18n.locale}/online_applications"
  end

end
