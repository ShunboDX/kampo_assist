require "rails_helper"

RSpec.describe "SearchSession flow", type: :system do
  let!(:kampo) { create(:kampo) }

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

  # seedに存在する値に依存しないため、画面上のチェックは「id」で行う。
  # ただし、Step1では「全身症候」が除外されるので、それ以外のMedicalAreaを1つ用意する。
  let!(:medical_area) do
    MedicalArea.find_or_create_by!(name: "呼吸器") do |a|
      # display_order が必須の場合に備えて入れる（不要なら無視される）
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
    # --- login ---
    visit new_user_session_path

    # ラベル文言差異に強いように name/id で入れる（Sorceryのフォーム前提）
    fill_in "email", with: user.email
    fill_in "password", with: "password"
    click_button "ログイン"

    # --- Step1 ---
    visit step1_search_path
    expect(page).to have_content("漢方検索 ステップ1")

    # 左：領域チェック（idで確実に）
    check "medical_area_#{medical_area.id}"

    # Turboで右カラム（病名）が更新されるのを待つ
    expect(page).to have_content("病名を選択（複数可）")
    expect(page).to have_content(disease.name)

    # 右：病名チェック（idで確実に）
    check "disease_#{disease.id}"

    click_button "症状を選ぶ（ステップ2へ）"

    # --- Step2 ---
    expect(page).to have_content("漢方検索 ステップ2：症状の選択")
    expect(page).to have_content(symptom.name)

    check "symptom_#{symptom.id}"

    # results に飛ばすフォームだけを狙って submit
    within("form[action='#{results_search_path}']") do
      click_button "検索"
    end

    # --- Results ---
    # ここは“特定の漢方名”や“ヒット件数”に依存しない
    expect(page).to have_content("検索結果")
    expect(page).to have_content("件の漢方候補が見つかりました")
    expect(page).to have_content("1位").or have_content("1位 候補")

    # 条件表示が出ていること（再検索一致の担保）
    expect(page).to have_content(medical_area.name)
    expect(page).to have_content(disease.name)
    expect(page).to have_content(symptom.name)

    # --- History list ---
    visit search_sessions_path
    expect(page).to have_content("検索履歴")
    expect(page).to have_link("詳細へ")

    click_link "詳細へ"
    expect(page).to have_content("検索履歴 詳細")

    click_link "この条件で再検索" # or click_button

    expect(page).to have_content("漢方検索 結果一覧")
    expect(page).to have_content(kampo.name)
  end
end
