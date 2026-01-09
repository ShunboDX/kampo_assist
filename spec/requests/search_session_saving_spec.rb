require "rails_helper"

RSpec.describe "SearchSession saving", type: :request do
  let(:user) { create(:user, password: "password", password_confirmation: "password") }

  def login_as(user, password: "password")
    post user_session_path, params: { email: user.email, password: password }
  end

  it "creates a SearchSession on results when logged in" do
    login_as(user)

    # KampoSearchをstubして、結果の中身に依存しないようにする
    allow(KampoSearch).to receive(:new).and_return(double(call: []))

    expect {
      get results_search_path, params: {
        medical_area_ids: [ "1" ],
        disease_ids: [ "2" ],
        symptom_ids: [ "3" ]
      }
    }.to change { user.search_sessions.count }.by(1)
  end

  it "does not create a SearchSession when conditions are blank" do
    login_as(user)
    allow(KampoSearch).to receive(:new).and_return(double(call: []))

    expect {
      get results_search_path, params: {
        medical_area_ids: [],
        disease_ids: [],
        symptom_ids: []
      }
    }.not_to change { user.search_sessions.count }
  end
end
