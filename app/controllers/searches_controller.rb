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
    # 領域（複数）
    medical_area_ids = Array(params[:medical_area_ids]).reject(&:blank?)
    @medical_areas = MedicalArea.where(id: medical_area_ids)

    # 病名（複数）
    disease_ids = Array(params[:disease_ids]).reject(&:blank?)
    @diseases = Disease.where(id: disease_ids)
  end
end
