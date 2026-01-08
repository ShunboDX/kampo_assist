require "rails_helper"

RSpec.describe "Re-search from SearchSession", type: :system do
  let(:user) { create(:user, password: "password", password_confirmation: "password") }

  it "navigates to results with same conditions" do
    # まず履歴を作る
    ss = user.search_sessions.create!(
      conditions: {
        "medical_area_ids" => ["1"],
        "disease_ids"      => ["2"],
        "symptom_ids"      => ["3"]
      }
    )

    # ログイン（画面操作）
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password"
    click_button "ログイン"

    # KampoSearchはstub（system specでもOK）
    allow(KampoSearch).to receive(:new).and_return(double(call: []))

    # 詳細へ
    visit search_session_path(ss)

    # ボタンを押す
    click_link "この条件で再検索"

    # resultsへ遷移し、クエリに条件が含まれていることを確認
    expect(page).to have_current_path(/\/search\/results/)
    expect(page.current_url).to include("medical_area_ids")
    expect(page.current_url).to include("disease_ids")
    expect(page.current_url).to include("symptom_ids")
  end
end
