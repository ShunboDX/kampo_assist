class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :authorizations, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  validates :password, presence: true, confirmation: true, if: :password_required?

  private

  def password_required?
    authorizations.blank?
  end
end
