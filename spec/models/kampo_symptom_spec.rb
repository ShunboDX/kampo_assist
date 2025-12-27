require "rails_helper"

RSpec.describe KampoSymptom, type: :model do
  it "factoryが有効である" do
    expect(build(:kampo_symptom)).to be_valid
  end

  it "kampoとsymptomに紐づく" do
    ks = create(:kampo_symptom)
    expect(ks.kampo).to be_present
    expect(ks.symptom).to be_present
  end
end
