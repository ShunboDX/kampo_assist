class SearchesController < ApplicationController
  before_action :require_login, only: %i[step2]

  def step1
    @medical_areas = MedicalArea
                   .where.not(name: [ "全身症候" ])
                   .order(:id)

    medical_area_ids = medical_area_ids_param

    if medical_area_ids.present?
      @selected_medical_areas = MedicalArea.where(id: medical_area_ids)

      @diseases = Disease.where(medical_area_id: medical_area_ids)
                         .distinct
                         .order(:id)
    else
      @selected_medical_areas = MedicalArea.none
      @diseases = Disease.none
    end
  end

  def step2
    @medical_area_ids = medical_area_ids_param
    @disease_ids      = disease_ids_param

    @medical_areas = MedicalArea
      .where.not(name: [ "血液" ])
      .order(
        Arel.sql("CASE WHEN name = '全身症候' THEN 0 ELSE 1 END"),
        :id
      )

    if @medical_area_ids.present?
      @symptoms = Symptom.where(medical_area_id: @medical_area_ids)
                         .order(:id)
    else
      @symptoms = Symptom.none
    end

    @diseases = Disease.where(id: @disease_ids)
  end

  def results
    builder = SearchResultsBuilder.new(
      user: current_user,
      params: params,
      page: params[:page]
    ).call

    @medical_areas = builder.medical_areas
    @diseases      = builder.diseases
    @symptoms      = builder.symptoms

    @no_condition = builder.no_condition
    @results      = builder.results

    @show_login_prompt = builder.show_login_prompt
    @search_session    = builder.search_session
    @search_case_note  = builder.search_case_note
  end

  private

  def array_param(key)
    Array(params[key]).reject(&:blank?)
  end

  def medical_area_ids_param
    array_param(:medical_area_ids)
  end

  def disease_ids_param
    array_param(:disease_ids)
  end

  def symptom_ids_param
    array_param(:symptom_ids)
  end

  def require_login
    return if logged_in?

    if turbo_frame_request?
      render partial: "shared/login_required_frame",
            status: :unauthorized
    else
      redirect_to new_user_session_path, alert: "ログインしてください"
    end
  end
end
