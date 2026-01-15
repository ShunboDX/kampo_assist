class User < ApplicationRecord
  enum :role, { user: 0, admin: 1 }
  authenticates_with_sorcery!

  has_many :authorizations, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_kampos, through: :favorites, source: :kampo
  has_many :search_sessions, dependent: :destroy
  has_many :case_notes, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  validates :password, presence: true, confirmation: true, if: :password_required?

  private

  def password_required?
    authorizations.blank?
  end
end
