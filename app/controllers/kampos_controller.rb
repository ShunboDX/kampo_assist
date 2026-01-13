class KamposController < ApplicationController
  def show
    @kampo = Kampo.find(params[:id])
    @favorited = logged_in? && current_user.favorites.exists?(kampo_id: @kampo.id)

    if current_user && params[:search_session_id].present?
      @search_session = current_user.search_sessions.find_by(id: params[:search_session_id])

      @case_note = current_user.case_notes.find_by(
        kampo_id: @kampo.id,
        search_session_id: @search_session&.id
      )
    end
  end
end
