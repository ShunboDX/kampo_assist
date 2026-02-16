require "rails_helper"

RSpec.describe "SearchSession flow", type: :system do
  let!(:user) do
    User.create!(
      email: "test@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  # Step1用データ（アプリの実装に合わせて必要なら増やす）
  let!(:medical_area) { create(:medical_area, name: "内科") }
  let!(:disease)      { create(:disease, name: "かぜ", medical_area: medical_area) }
  let!(:symptom)      { create(:symptom, name: "発熱", medical_area: medical_area) }

  # 検索結果で出したい漢方
  let!(:kampo) { create(:kampo, name: "葛根湯") }

  before do
    # ここはあなたの関連に合わせて：disease/symptom と kampo を紐付け
    kampo.diseases << disease
    kampo.symptoms << symptom
  end

  it "saves search session and allows re-search from history" do
    # ログイン
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password"
    click_button "ログイン"

    # Step1: 領域/傷病選択（UIに合わせて操作）
    visit step1_search_path # 例：ルート名が違うなら修正

    check "内科"
    check "かぜ"
    click_button "症状を選ぶ（ステップ2へ）" # Step2へ

    # Step2 にいること確認
    expect(page).to have_content("漢方検索 ステップ2：症状の選択")

    # 症状を選ぶ
    check "発熱" # ← symptom.name に合わせる

    # 右カラムの「症状フォーム」内の submit を押す
    within("form[action='#{results_search_path}']") do
    click_button "検索"
    end

    # Resultsで結果確認
    expect(page).to have_content("葛根湯")

    # 履歴ページへ（導線があるなら click_on にする）
    visit search_sessions_path

    expect(page).to have_content("ヒット 1件")
    expect(page).to have_content("葛根湯")
    expect(page).to have_link("詳細へ")

    click_link "詳細へ"

    # 再検索後も結果が出ることを確認
    expect(page).to have_content("葛根湯")
  end
end
