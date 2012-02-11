class SponsorsController < ApplicationController

  def create
    @online_application = OnlineApplication.find(params[:online_application_id])
    @sponsor = @online_application.sponsors.create(params[:sponsor])
    redirect_to online_application_path(@online_application)
  end
  
  def destroy
    @online_application = OnlineApplication.find(params[:online_application_id])
    @sponsor = @online_application.sponsors.find(params[:id])
    @sponsor.destroy
    redirect_to online_application_path(@online_application)
  end
  
end
