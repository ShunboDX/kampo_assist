require "rails_helper"

RSpec.describe "Re-search from SearchSession", type: :system do
  let!(:user) do
    User.create!(
      email: "test@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  it "navigates to results with same conditions" do
    ss = user.search_sessions.create!(
      conditions: {
        "medical_area_ids" => [ "1" ],
        "disease_ids"      => [ "2" ],
        "symptom_ids"      => [ "3" ]
      }
    )

    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password"
    click_button "ログイン"

    expect(page).not_to have_content("ログインしてください")

    allow(KampoSearch).to receive(:new).and_return(double(call: []))

    visit search_session_path(ss)
    expect(page).to have_content("検索履歴 詳細")

    click_on "この条件で再検索"
    expect(page).to have_current_path(/\/search\/results/)
    expect(page.current_url).to include("medical_area_ids")
    expect(page.current_url).to include("disease_ids")
    expect(page.current_url).to include("symptom_ids")
  end
end
