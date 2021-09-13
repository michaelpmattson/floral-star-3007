class MechanicsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @mechanics = Mechanic.all
  end

  def show
    @mechanic = Mechanic.find(params[:id])
  end

  def update
    ride     = Ride.find(params[:ride_id])
    mechanic = Mechanic.find(params[:id])
    mechanic.rides << ride
    binding.pry
    redirect_to "/mechanics/#{mechanic.id}"
  end

  private

  def record_not_found
    flash[:error] = "Oops, we cannot find this record"
    redirect_to :back
  end
end
