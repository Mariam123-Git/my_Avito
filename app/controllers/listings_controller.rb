class ListingsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_listing, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_user!, only: [ :edit, :update, :destroy ]

  def index
    @listings = Listing.search(params).active.recent.includes(:user, :category, :city).page(params[:page]).per(20)
  end

  def show
    @related_listings = @listing.category.listings.active.where.not(id: @listing.id).limit(4)
  end

  def new
    @listing = current_user.listings.build
  end

  def create
    @listing = current_user.listings.build(listing_params)
    @listing.active = true
    if @listing.save
      redirect_to @listing, notice: "Annonce créée avec succès."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @listing.update(listing_params)
      redirect_to @listing, notice: "Annonce mise à jour avec succès."
    else
      render :edit
    end
  end

  def destroy
    @listing.destroy
    redirect_to listings_url, notice: "Annonce supprimée avec succès."
  end

  def my_listings
  end

  def delete_image
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(:title, :description, :price, :category_id, :city_id, images: [])
  end

  def authorize_user!
    unless @listing.user == current_user || current_user.admin?
      redirect_to root_path, alert: "Vous n'êtes pas autorisé à effectuer cette action."
    end
  end
end
