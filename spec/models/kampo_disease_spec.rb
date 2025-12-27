require "rails_helper"

RSpec.describe KampoDisease, type: :model do
  it "factoryが有効である" do
    expect(build(:kampo_disease)).to be_valid
  end

  it "kampoとdiseaseに紐づく" do
    kd = create(:kampo_disease)
    expect(kd.kampo).to be_present
    expect(kd.disease).to be_present
  end
end
