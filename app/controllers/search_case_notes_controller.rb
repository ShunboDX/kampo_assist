class SearchCaseNotesController < ApplicationController
  before_action :require_login

  def update
    search_session = current_user.search_sessions.find(params[:search_session_id])

    note = current_user.case_notes.find_or_initialize_by(
      search_session_id: search_session.id,
      kampo_id: nil
    )

    note.body = params.require(:case_note).permit(:body)[:body]

    if note.save
      redirect_to params[:return_to].presence || results_search_path(search_session_id: search_session.id),
                  notice: "検索メモを保存しました"
    else
      # results 画面に戻してエラー表示したい場合は、最小なら notice なしで戻すでもOK
      redirect_to params[:return_to].presence || results_search_path(search_session_id: search_session.id),
                  alert: note.errors.full_messages.join(", ")
    end
  end
end
