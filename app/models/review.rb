class Review < ApplicationRecord
  belongs_to :user
  belongs_to :reviewer, class_name: "User"

  # Validations
  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :comment, presence: true, length: { minimum: 10, maximum: 500 }

  # Empêcher un utilisateur de laisser plusieurs avis pour le même utilisateur
  validates :reviewer_id, uniqueness: { scope: :user_id, message: "Vous avez déjà laissé un avis pour cet utilisateur" }

  # Empêcher un utilisateur de se laisser un avis à lui-même
  validate :not_self_review

  # Callbacks
  after_save :update_user_average_rating
  after_destroy :update_user_average_rating

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :highest_rated, -> { order(rating: :desc) }
  scope :lowest_rated, -> { order(rating: :asc) }

  private

  def not_self_review
    if user_id == reviewer_id
      errors.add(:base, "Vous ne pouvez pas laisser un avis sur vous-même")
    end
  end

  def update_user_average_rating
    # Mettre à jour la note moyenne de l'utilisateur
    user.update_average_rating if user.present?
  end
end
