class UsersController < ApplicationController
  def show
     @user = User.find_by(id: params[:id])
    # Rails.logger.debug "Received ID: #{params[:id]}"
    if @user.nil?
      redirect_to root_path, alert: "User not found."
    else
      @listings = @user.listings.active.recent.includes(:category, :city).page(params[:page]).per(12)
    end
  end

  def my_listings
    authenticate_user!
    @active_listings = current_user.listings.active.recent.includes(:category, :city).page(params[:active_page]).per(10)
    @inactive_listings = current_user.listings.where(active: false).recent.includes(:category, :city).page(params[:inactive_page]).per(10)
  end

  def favorites
    authenticate_user!
    @favorites = current_user.favorites.includes(listing: [ :category, :city ]).page(params[:page]).per(12)
  end
end
