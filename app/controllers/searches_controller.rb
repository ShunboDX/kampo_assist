class SearchesController < ApplicationController
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

    # 選択された病名／領域の表示用
    @diseases = Disease.where(id: @disease_ids)
  end

  def step3
    medical_area_ids = Array(params[:medical_area_ids]).reject(&:blank?)
    disease_ids      = Array(params[:disease_ids]).reject(&:blank?)
    symptom_ids      = Array(params[:symptom_ids]).reject(&:blank?)

    @medical_areas = MedicalArea.where(id: medical_area_ids)
    @diseases      = Disease.where(id: disease_ids)
    @symptoms      = Symptom.where(id: symptom_ids)

    # --- ここからスコア計算ロジック ---

    # 選択された傷病・症状との関連をまとめて取得
    disease_links = KampoDisease.where(disease_id: disease_ids)
                                .group_by(&:kampo_id)
    symptom_links = KampoSymptom.where(symptom_id: symptom_ids)
                                .group_by(&:kampo_id)

    # 「どれか一つでも関係がある漢方」を候補に
    kampo_ids = (disease_links.keys + symptom_links.keys).uniq
    @kampo_results = Kampo.where(id: kampo_ids).map do |kampo|
      disease_score = Array(disease_links[kampo.id]).sum { |kd| kd.weight.to_i }
      # 症状は全部1点扱い（weight があるならそれを使ってもOK）
      symptom_score = Array(symptom_links[kampo.id]).size * 1

      total_score = disease_score + symptom_score

      {
        kampo: kampo,
        total_score: total_score,
        disease_score: disease_score,
        symptom_score: symptom_score
      }
    end

    # スコアの高い順にソート
    @kampo_results.sort_by! { |h| -h[:total_score] }
  endseases = Disease.where(id: disease_ids)
  end
end
