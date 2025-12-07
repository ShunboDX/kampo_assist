class Kampo < ApplicationRecord
  has_many :kampo_diseases, dependent: :destroy
  has_many :diseases, through: :kampo_diseases

  has_many :kampo_symptoms, dependent: :destroy
  has_many :symptoms, through: :kampo_symptoms
end
