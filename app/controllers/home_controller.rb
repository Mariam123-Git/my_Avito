class HomeController < ApplicationController
  def index
    @featured_listings = Listing.active.recent.includes(:user, :category, :city).limit(8)
    @categories = Category.main_categories.includes(:subcategories)
    @popular_cities = City.joins(:listings)
                         .select('cities.*, COUNT(listings.id) as listings_count')
                         .group('cities.id')
                         .order('listings_count DESC')
                         .limit(8)
  end

end
