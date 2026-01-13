class Kampo < ApplicationRecord
  has_many :kampo_diseases, dependent: :destroy
  has_many :diseases, through: :kampo_diseases

  has_many :kampo_symptoms, dependent: :destroy
  has_many :symptoms, through: :kampo_symptoms

  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user

  has_many :case_notes, dependent: :nullify
end
