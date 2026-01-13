class CaseNote < ApplicationRecord
  belongs_to :user
  belongs_to :kampo, optional: true
  belongs_to :search_session, optional: true

  validates :body, presence: true, length: { maximum: 1000 }
end
