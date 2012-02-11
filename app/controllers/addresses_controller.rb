class AddressesController < ApplicationController

  def create
    @online_application = OnlineApplication.find(params[:online_application_id])
    @address = @online_application.addresses.create(params[:address])
    redirect_to online_application_path(@online_application)
  end
  
  def destroy
    @online_application = OnlineApplication.find(params[:online_application_id])
    @address = @online_application.addresses.find(params[:id])
    @address.destroy
    redirect_to online_application_path(@online_application)
  end
  
end
