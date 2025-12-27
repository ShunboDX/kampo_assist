require "rails_helper"

RSpec.describe Symptom, type: :model do
  it "factoryが有効である" do
    expect(build(:symptom)).to be_valid
  end

  it "medical_areaに紐づく" do
    symptom = create(:symptom)
    expect(symptom.medical_area).to be_present
  end
end
