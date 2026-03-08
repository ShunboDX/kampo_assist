require "rails_helper"

RSpec.describe "SearchSession flow", type: :system do
  let!(:kampo) { create(:kampo) }

  def sign_in_as(user, password: "password")
    visit new_user_session_path
    fill_in "email", with: user.email
    fill_in "password", with: password
    click_button "ログイン"
    expect(page).to have_current_path(root_path, ignore_query: true)
  end

  let(:result) do
    double(
      kampo: kampo,
      total_score: 5,
      disease_score: 5,
      symptom_score: 0
    )
  end

  before do
    allow(KampoSearch).to receive(:new) do |**_kwargs|
      double(call: [ result ])
    end
  end

  let!(:user) do
    User.create!(
      email: "test@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  let!(:medical_area) do
    MedicalArea.find_or_create_by!(name: "呼吸器") do |a|
      a.display_order = 1 if a.respond_to?(:display_order=) && a.display_order.blank?
    end
  end

  let!(:disease) do
    Disease.find_or_create_by!(medical_area: medical_area, name: "感冒")
  end

  let!(:symptom) do
    Symptom.find_or_create_by!(medical_area: medical_area, name: "咳")
  end

  it "saves search session and allows re-search from history (stable)" do
    sign_in_as(user)

    visit step1_search_path
    expect(page).to have_content("漢方検索 ステップ1")

    visit step1_search_path(medical_area_ids: [ medical_area.id ])
    expect(page).to have_content("病名を選択（複数可）")
    expect(page).to have_content(disease.name)

    visit step2_search_path(
      medical_area_ids: [ medical_area.id ],
      disease_ids: [ disease.id ]
    )
    expect(page).to have_content("漢方検索 ステップ2：症状の選択")
    expect(page).to have_content(symptom.name)

    visit results_search_path(
      medical_area_ids: [ medical_area.id ],
      disease_ids: [ disease.id ],
      symptom_ids: [ symptom.id ]
    )

    expect(page).to have_content("検索結果")
    expect(page).to have_content("件の漢方候補が見つかりました")
    expect(page).to have_content("1位").or have_content("1位 候補")

    expect(page).to have_content(medical_area.name)
    expect(page).to have_content(disease.name)
    expect(page).to have_content(symptom.name)

    search_session = SearchSession.order(created_at: :desc).first

    visit search_sessions_path
    expect(page).to have_content("検索履歴")
    expect(page).to have_link("詳細へ")

    within("ul.divide-y > li", match: :first) do
      click_link "詳細へ"
    end

    expect(page).to have_current_path(search_session_path(search_session), ignore_query: true)
    expect(page).to have_content("検索履歴 詳細")

    click_link "この条件で再検索"

    expect(page).to have_content("漢方検索 結果一覧")
    expect(page).to have_content(kampo.name)
  end
end
