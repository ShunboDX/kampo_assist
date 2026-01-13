class CaseNotesController < ApplicationController
  before_action :require_login

  def index
    @case_notes = current_user.case_notes.order(created_at: :desc)
  end

  def new
    @case_note = current_user.case_notes.build
  end

  def create
    @case_note = current_user.case_notes.build(case_note_params)

    if @case_note.save
      redirect_to case_notes_path, notice: "症例メモを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def case_note_params
    params.require(:case_note).permit(:body)
  end
end
