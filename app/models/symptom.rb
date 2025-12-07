class Symptom < ApplicationRecord
  belongs_to :medical_area

  has_many :kampo_symptoms, dependent: :destroy
  has_many :kampos, through: :kampo_symptoms
end
