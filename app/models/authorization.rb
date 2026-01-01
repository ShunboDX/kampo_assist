class Authorization < ApplicationRecord
  belongs_to :user

  validates :provider, presence: true
  validates :uid, presence: true
  validates :uid, uniqueness: { scope: :provider }

  def self.link!(user:, provider:, uid:, email: nil, name: nil)
    create!(
      user: user,
      provider: provider,
      uid: uid,
      email: email,
      name: name
    )
  end
end
