class MedicalArea < ApplicationRecord
  has_many :diseases, dependent: :destroy
  has_many :symptoms, dependent: :destroy
end
