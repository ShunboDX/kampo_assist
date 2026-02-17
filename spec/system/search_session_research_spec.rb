# spec/system/search_sessions_spec.rb
require "rails_helper"

RSpec.describe "SearchSession flow", type: :system do
  let!(:user) do
    User.create!(email: "test@example.com", password: "password", password_confirmation: "password")
  end

  # seedに存在する名前で作る（or 既存を使う）
  let!(:medical_area) { MedicalArea.find_or_create_by!(name: "呼吸器") { |a| a.display_order = 1 } }
  let!(:disease)      { Disease.find_or_create_by!(medical_area: medical_area, name: "感冒") }
  let!(:symptom)      { Symptom.find_or_create_by!(medical_area: medical_area, name: "咳") }

  let!(:kampo) { create(:kampo, name: "葛根湯") }

  before do
    kampo.diseases << disease
    kampo.symptoms << symptom
  end

  it "saves search session and allows re-search from history" do
    # ログイン
    visit new_user_session_path
    fill_in "email", with: user.email
    fill_in "password", with: "password"
    click_button "ログイン"

    # Step1
    visit step1_search_path
    expect(page).to have_content("漢方検索 ステップ1")

    check "medical_area_#{medical_area.id}"   # ★IDで選択
    expect(page).to have_content("感冒")      # Turbo更新待ち

    check "disease_#{disease.id}"            # ★IDで選択
    click_button "症状を選ぶ（ステップ2へ）"

    # Step2
    expect(page).to have_content("漢方検索 ステップ2")
    check "symptom_#{symptom.id}"            # ★IDで選択

    within("form[action='#{results_search_path}']") do
      click_button "検索"
    end

    # Results
    expect(page).to have_content("葛根湯")

    # 履歴（あなたのUI仕様に合わせる）
    visit search_sessions_path
    expect(page).to have_content("ヒット 1件")
    expect(page).to have_content("葛根湯")
    click_link "詳細へ"

    # 再検索結果
    expect(page).to have_content("葛根湯")
  end
end
