require "rails_helper"

RSpec.describe Disease, type: :model do
  it "factoryが有効である" do
    expect(build(:disease)).to be_valid
  end

  it "nameがないと無効" do
    disease = build(:disease, name: nil)
    expect(disease).not_to be_valid
    expect(disease.errors[:name]).to be_present
  end

  it "medical_areaに紐づく" do
    disease = create(:disease)
    expect(disease.medical_area).to be_present
  end
end
