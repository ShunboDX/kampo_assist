require "rails_helper"

RSpec.describe SearchResultsBuilder do
  let(:user) { create(:user) }

  it "builds results data consistently" do
    kampo = create(:kampo)
    result = double(kampo: kampo, total_score: 1, disease_score: 1, symptom_score: 0)

    # runner をスタブ（検索ロジックに依存しない）
    allow(KampoSearchRunner).to receive(:new).and_return(double(call: double(no_condition: false, results: [ result ])))

    # saver をスタブ（DB保存の詳細に依存しない）
    fake_ss = create(:search_session, user: user, conditions: { "disease_ids" => [ "1" ] }, conditions_hash: "x")
    allow(SearchSessionSaver).to receive(:new).and_return(double(call: fake_ss))

    builder = described_class.new(
      user: user,
      params: { disease_ids: [ "1" ] },
      page: 1
    ).call

    expect(builder.no_condition).to be(false)
    expect(builder.results).to be_present
    expect(builder.search_session).to eq(fake_ss)
    expect(builder.show_login_prompt).to be(false)
  end

  it "sets show_login_prompt true when user is nil" do
    allow(KampoSearchRunner).to receive(:new).and_return(double(call: double(no_condition: true, results: [])))
    allow(SearchSessionSaver).to receive(:new).and_return(double(call: nil))

    builder = described_class.new(user: nil, params: {}, page: 1).call
    expect(builder.show_login_prompt).to be(true)
  end
end
