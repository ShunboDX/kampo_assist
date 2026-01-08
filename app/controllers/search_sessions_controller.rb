class SearchSessionsController < ApplicationController
  before_action :require_login

  def index
    @search_sessions = current_user.search_sessions.order(created_at: :desc)
  end

  def show
    @search_session = current_user.search_sessions.find(params[:id])

    disease_ids = Array(@search_session.conditions["disease_ids"]).reject(&:blank?)
    symptom_ids = Array(@search_session.conditions["symptom_ids"]).reject(&:blank?)

    if disease_ids.blank? && symptom_ids.blank?
      @results = []
    else
      @results = KampoSearch.new(disease_ids: disease_ids, symptom_ids: symptom_ids).call
    end
  end
end
