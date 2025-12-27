require "rails_helper"

RSpec.describe Kampo, type: :model do
  it "factoryが有効である" do
    expect(build(:kampo)).to be_valid
  end
end
