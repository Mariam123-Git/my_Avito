class Listing < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :city

  has_many_attached :images

  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :images, presence: true

  scope :active, -> { where(active: true) }
  scope :recent, -> { order(created_at: :desc) }

  def self.search(params)
    listings = Listing.all

    if params[:query].present?
      listings = listings.where("title LIKE ? OR description LIKE ?",
                               "%#{params[:query]}%",
                               "%#{params[:query]}%")
    end

    if params[:category_id].present?
      listings = listings.where(category_id: params[:category_id])
    end

    if params[:city_id].present?
      listings = listings.where(city_id: params[:city_id])
    end

    if params[:min_price].present?
      listings = listings.where("price >= ?", params[:min_price])
    end

    if params[:max_price].present?
      listings = listings.where("price <= ?", params[:max_price])
    end

    listings
  end
end
