require "rails_helper"

RSpec.describe "Admin Kampo management", type: :system do
  before { driven_by(:rack_test) }

  let(:password) { "password" }

  def login_via_ui(user)
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: password
    click_button "ログイン"
  end

  it "allows admin to list, edit, and update kampo" do
    admin = User.create!(
        email: "admin@example.com",
        password: password,
        password_confirmation: password,
        role: :admin
    )


    admin.update!(
        role: :admin,
        password: password,
        password_confirmation: password
    )


    expect(admin.reload.admin_user?).to eq(true) # ★必ず it の中！

    kampo = Kampo.create!(
      name: "当帰芍薬散",
      kana_name: "とうきしゃくやくさん",
      note: "",
      detail: ""
    )

    login_via_ui(admin)

    visit admin_kampos_path
    expect(page).to have_content("漢方一覧")
    expect(page).to have_content("当帰芍薬散")

    click_link "編集", href: edit_admin_kampo_path(kampo)

    fill_in "漢方名", with: "当帰芍薬散（更新）"
    click_button "更新する"

    expect(page).to have_content("更新しました")
    expect(page).to have_content("当帰芍薬散（更新）")
  end
end
