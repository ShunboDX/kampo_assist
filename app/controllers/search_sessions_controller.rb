class SearchSessionsController < ApplicationController
  before_action :require_login

  def index
    @search_sessions = current_user.search_sessions
                                    .includes(:case_note) # ← 1件ずつ取りに行くのを防ぐ
                                    .order(created_at: :desc)
                                    .page(params[:page])
                                    .per(25)
  end

  def show
    @search_session = current_user.search_sessions.find(params[:id])

    disease_ids = Array(@search_session.conditions["disease_ids"]).reject(&:blank?)
    symptom_ids = Array(@search_session.conditions["symptom_ids"]).reject(&:blank?)

    results =
      if disease_ids.blank? && symptom_ids.blank?
        []
      else
        KampoSearch.new(disease_ids: disease_ids, symptom_ids: symptom_ids).call
      end

    @results = Kaminari.paginate_array(results).page(params[:page]).per(10)
  end
end
