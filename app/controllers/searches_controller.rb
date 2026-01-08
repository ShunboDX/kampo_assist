class SearchesController < ApplicationController
  before_action :require_login, only: %i[step2]

  def step1
    @medical_areas = MedicalArea.all.order(:id)

    # 複数領域に対応（"-", nil 対策で Array() + reject）
    medical_area_ids = Array(params[:medical_area_ids]).reject(&:blank?)

    if medical_area_ids.present?
      # 選択された領域たち
      @selected_medical_areas = MedicalArea.where(id: medical_area_ids)

      # 選択された領域に紐づく病名を全部まとめて取得
      @diseases = Disease.where(medical_area_id: medical_area_ids)
                         .distinct
                         .order(:id)
    else
      @selected_medical_areas = MedicalArea.none
      @diseases = Disease.none
    end
  end

  def step2
    # Step1 から引き継いだもの
    @medical_area_ids = Array(params[:medical_area_ids]).reject(&:blank?)
    @disease_ids      = Array(params[:disease_ids]).reject(&:blank?)

    # 左カラム：領域一覧（全部表示してOK）
    @medical_areas = MedicalArea.all.order(:id)

    # 右カラム：症状一覧（選択された領域だけ絞る）
    if @medical_area_ids.present?
      @symptoms = Symptom.where(medical_area_id: @medical_area_ids)
                         .order(:id)
    else
      @symptoms = Symptom.none
    end

    # 選択された病名の表示用
    @diseases = Disease.where(id: @disease_ids)
  end

  def results
    medical_area_ids = Array(params[:medical_area_ids]).reject(&:blank?)
    disease_ids      = Array(params[:disease_ids]).reject(&:blank?)
    symptom_ids      = Array(params[:symptom_ids]).reject(&:blank?)

    @medical_areas = MedicalArea.where(id: medical_area_ids)
    @diseases      = Disease.where(id: disease_ids)
    @symptoms      = Symptom.where(id: symptom_ids)

    # --- ここからはサービスに委譲 ---
    if disease_ids.blank? && symptom_ids.blank?
      # 条件が何も選ばれてないパターン
      @no_condition = true
      @results = []
    else
      @no_condition = false
      @results = KampoSearch.new(
        disease_ids: disease_ids,
        symptom_ids: symptom_ids
      ).call
    end
  
    # ★追加：未ログインならログイン誘導を表示する
    @show_login_prompt = !logged_in?

    # ★追加：results表示時に履歴保存（#160）
    save_search_session!(medical_area_ids:, disease_ids:, symptom_ids:)
  end

  private

  def save_search_session!(medical_area_ids:, disease_ids:, symptom_ids:)
    # require_login してるので基本 current_user はいる想定だが念のため
    return unless current_user

    conditions = {
      "medical_area_ids" => medical_area_ids,
      "disease_ids"      => disease_ids,
      "symptom_ids"      => symptom_ids
    }.compact_blank

    return if conditions.blank?

    hash = SearchSession.generate_hash(conditions)

    search_session = current_user.search_sessions.find_or_initialize_by(conditions_hash: hash)
    search_session.conditions = conditions
    search_session.save!

    enforce_search_session_limit!(current_user, 100)
  end

  def enforce_search_session_limit!(user, limit)
    over = user.search_sessions.count - limit
    return if over <= 0

    # 集約運用なので updated_at が古い順に消すと自然
    user.search_sessions.order(updated_at: :asc).limit(over).delete_all
  end
end
