require "rails_helper"

RSpec.describe KampoSearchRunner do
  it "sets no_condition true and returns empty results when both ids blank" do
    runner = described_class.new(disease_ids: [ "" ], symptom_ids: []).call
    expect(runner.no_condition).to be(true)
    expect(runner.results).to eq([])
  end

  it "calls KampoSearch when either disease_ids or symptom_ids present" do
    fake_result = [ double ]

    expect(KampoSearch).to receive(:new)
      .with(disease_ids: [ "1" ], symptom_ids: [])
      .and_return(double(call: fake_result))

    runner = described_class.new(disease_ids: [ "1" ], symptom_ids: []).call
    expect(runner.no_condition).to be(false)
    expect(runner.results).to eq(fake_result)
  end
end
