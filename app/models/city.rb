class City < ApplicationRecord
  has_many :listings
  belongs_to :region
  
  validates :name, presence: true
end
