require "rails_helper"

RSpec.describe "SearchSession flow", type: :system do
  let!(:user) do
    User.create!(email: "test@example.com", password: "password", password_confirmation: "password")
  end

  # seedにあるものに寄せる（CIで安定）
  let!(:medical_area) { MedicalArea.find_or_create_by!(name: "呼吸器") { |a| a.display_order ||= 1 } }
  let!(:disease)      { Disease.find_or_create_by!(medical_area: medical_area, name: "感冒") }
  let!(:symptom)      { Symptom.find_or_create_by!(medical_area: medical_area, name: "咳") }

  let!(:kampo) { create(:kampo, name: "テスト漢方") }

  before do
    kampo.diseases << disease
    kampo.symptoms << symptom
  end

  it "saves search session and allows re-search from history" do
    # ログイン（ラベル依存を避けるなら email/password 推奨）
    visit new_user_session_path
    fill_in "email", with: user.email
    fill_in "password", with: "password"
    click_button "ログイン"

    # Step1
    visit step1_search_path
    expect(page).to have_content("漢方検索 ステップ1")

    check "medical_area_#{medical_area.id}"
    expect(page).to have_content("感冒") # Turbo更新待ち
    check "disease_#{disease.id}"

    click_button "症状を選ぶ（ステップ2へ）"

    # Step2
    expect(page).to have_content("漢方検索 ステップ2：症状の選択")
    check "symptom_#{symptom.id}"

    within("form[action='#{results_search_path}']") do
      click_button "検索"
    end

    # Results（特定の漢方名には依存しない）
    expect(page).to have_content("件の漢方候補が見つかりました")
    expect(page).to have_content("1位 候補").or have_content("1位")
    expect(page).to have_content("呼吸器")
    expect(page).to have_content("感冒")
    expect(page).to have_content("咳")

    # 履歴
    visit search_sessions_path
    expect(page).to have_content("ヒット 1件")
    expect(page).to have_content("漢方例：")
    expect(page).to have_link("詳細へ")

    click_link "詳細へ"

    # 再検索後
    expect(page).to have_content("件の漢方候補が見つかりました")
  end
end