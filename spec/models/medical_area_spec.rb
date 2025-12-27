require 'rails_helper'

RSpec.describe MedicalArea, type: :model do
  it "factoryが有効である" do
    expect(build(:medical_area)).to be_valid
  end

  it "nameがないと無効" do
    area = build(:medical_area, name: nil)
    expect(area).not_to be_valid
    expect(area.errors[:name]).to be_present
  end
end
