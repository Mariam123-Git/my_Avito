class Message < ApplicationRecord
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"
  belongs_to :listing

  # Scope to get messages between two users
  scope :between, ->(user1, user2) do
    where("(sender_id = ? AND recipient_id = ?) OR (sender_id = ? AND recipient_id = ?)", user1.id, user2.id, user2.id, user1.id)
  end
end
