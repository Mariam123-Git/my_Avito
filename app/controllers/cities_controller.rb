class CitiesController < ApplicationController
  def index
    @regions = Region.includes(:cities)
  end

  def show
    @city = City.find(params[:id])
    @listings = @city.listings.active.recent.page(params[:page]).per(20)
  end
end
