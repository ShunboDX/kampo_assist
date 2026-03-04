class SearchCaseNotesController < ApplicationController
  before_action :require_login

  def update
    search_session = current_user.search_sessions.find(params[:search_session_id])

    note = current_user.case_notes.find_or_initialize_by(
      search_session_id: search_session.id,
      kampo_id: nil
    )

    note.assign_attributes(case_note_params)

    if note.save
      redirect_to return_to_path(search_session),
                  notice: "検索メモを保存しました"
    else
      redirect_to return_to_path(search_session),
                  alert: note.errors.full_messages.join(", ")
    end
  end

  private

  def case_note_params
    params.require(:case_note).permit(:body)
  end

  def return_to_path(search_session)
    params[:return_to].presence || results_search_path(search_session_id: search_session.id)
  end
end
