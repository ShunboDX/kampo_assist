require "rails_helper"

RSpec.describe KampoSearchRunner do
  it "sets no_condition true and returns empty results when all conditions are blank" do
    runner = described_class.new(
      medical_area_ids: [],
      disease_ids: [ "" ],
      symptom_ids: [],
      keyword: ""
    ).call

    expect(runner.no_condition).to be(true)
    expect(runner.results).to eq([])
  end

  it "calls KampoSearch with filtered kampos when any condition is present" do
    fake_result = [ double ]
    filtered_kampos = Kampo.none

    query_double = instance_double(KampoSearchQuery, call: filtered_kampos)
    search_double = instance_double(KampoSearch, call: fake_result)

    expect(KampoSearchQuery).to receive(:new).with(
      medical_area_ids: [],
      disease_ids: [ "1" ],
      symptom_ids: [],
      keyword: ""
    ).and_return(query_double)

    expect(KampoSearch).to receive(:new).with(
      disease_ids: [ "1" ],
      symptom_ids: [],
      kampos_scope: filtered_kampos
    ).and_return(search_double)

    runner = described_class.new(
      medical_area_ids: [],
      disease_ids: [ "1" ],
      symptom_ids: [],
      keyword: ""
    ).call

    expect(runner.no_condition).to be(false)
    expect(runner.results).to eq(fake_result)
  end
end
