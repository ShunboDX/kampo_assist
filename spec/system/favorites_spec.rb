# spec/system/favorites_spec.rb
require "rails_helper"

RSpec.describe "Favorite flow", type: :system do
  let!(:user) do
    User.create!(
      email: "test@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  let!(:kampo) { create(:kampo, name: "葛根湯") }

  it "adds favorite from kampo detail and shows in favorites list" do
    visit new_user_session_path

    # ラベル一致が怪しい場合に備えて name/id で入れるのが安定
    fill_in "email", with: user.email
    fill_in "password", with: "password"
    click_button "ログイン"

    # ★ここ重要：ログインできてるか確認（ヘッダーにログアウトが出る等）
    expect(page).to have_button("ログアウト").or have_content("ログイン中")

    visit kampo_path(kampo)
    expect(page).to have_content("葛根湯")

    # まず「お気に入りする」があるか確認。無ければ解除ボタンの可能性もある
    if page.has_button?("お気に入りする")
      click_button "お気に入りする"
    else
      click_button "お気に入り解除"
    end

    visit favorites_path
    expect(page).to have_content("葛根湯")
  end
end
