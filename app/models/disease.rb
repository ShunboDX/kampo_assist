class Disease < ApplicationRecord
  belongs_to :medical_area

  has_many :kampo_diseases, dependent: :destroy
  has_many :kampos, through: :kampo_diseases
end
