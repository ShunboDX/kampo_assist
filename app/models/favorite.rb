class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :kampo

  validates :kampo_id, uniqueness: { scope: :user_id }
end