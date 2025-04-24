class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  has_many :listings, dependent: :destroy
  has_one_attached :avatar
  has_many :reviews, dependent: :destroy
  has_many :received_reviews, class_name: "Review", foreign_key: "user_id", dependent: :destroy
  has_many :given_reviews, class_name: "Review", foreign_key: "reviewer_id", dependent: :destroy

  # Association for sent messages
  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id", dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :phone_number, presence: true

  # Method for calculating average rating
  def average_rating
    received_reviews.average(:rating).to_f.round(1)
  end

  # Method to update average rating
  def update_average_rating
    # Optional: Add code here to store or use the average rating.
  end

  # Check if the user has reviewed another user
  def has_reviewed?(user)
    given_reviews.exists?(user: user)
  end

  # Get the review for a user
  def review_for(user)
    given_reviews.find_by(user: user)
  end
end
