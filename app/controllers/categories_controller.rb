class CategoriesController < ApplicationController
  def index
    @categories = Category.main_categories.includes(:subcategories)
  end

  def show
    @category = Category.find(params[:id])
    @listings = @category.listings.active.recent.page(params[:page]).per(20)
  end
end
