# app/services/search_results_builder.rb
class SearchResultsBuilder
  PER_PAGE = 5
  SEARCH_SESSION_LIMIT = 100

  attr_reader :medical_area_ids, :disease_ids, :symptom_ids,
              :medical_areas, :diseases, :symptoms,
              :no_condition, :results,
              :show_login_prompt, :search_session, :search_case_note

  def initialize(user:, params:, page:)
    @user  = user
    @params = params
    @page  = page

    @medical_area_ids = array_param(:medical_area_ids)
    @disease_ids      = array_param(:disease_ids)
    @symptom_ids      = array_param(:symptom_ids)

    @show_login_prompt = @user.nil?
    @search_case_note = nil
  end

  def call
    load_condition_records
    run_search_and_paginate
    save_search_session
    prepare_case_note
    self
  end

  private

  def array_param(key)
    Array(@params[key]).reject(&:blank?)
  end

  def load_condition_records
    @medical_areas = MedicalArea.where(id: @medical_area_ids)
    @diseases      = Disease.where(id: @disease_ids)
    @symptoms      = Symptom.where(id: @symptom_ids)
  end

  def run_search_and_paginate
    runner = KampoSearchRunner.new(disease_ids: @disease_ids, symptom_ids: @symptom_ids).call
    @no_condition = runner.no_condition
    @results = Kaminari.paginate_array(runner.results).page(@page).per(PER_PAGE)
  end

  def save_search_session
    @search_session = SearchSessionSaver.new(
      user: @user,
      medical_area_ids: @medical_area_ids,
      disease_ids: @disease_ids,
      symptom_ids: @symptom_ids,
      limit: SEARCH_SESSION_LIMIT
    ).call
  end

  def prepare_case_note
    return unless @user
    return unless @search_session

    @search_case_note = @user.case_notes.find_or_initialize_by(
      search_session_id: @search_session.id,
      kampo_id: nil
    )
  end
end
