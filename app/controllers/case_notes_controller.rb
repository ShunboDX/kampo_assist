class CaseNotesController < ApplicationController
  before_action :require_login
  before_action :set_case_note, only: [ :edit, :update, :destroy ]

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

  def edit
  end

  def update
    if @case_note.update(case_note_params)
      redirect_to case_notes_path, notice: "症例メモを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @case_note.destroy!
    redirect_to case_notes_path, notice: "症例メモを削除しました"
  end

  private

  def set_case_note
    @case_note = CaseNote.find(params[:id])
  end

  def case_note_params
    params.require(:case_note).permit(:body)
  end
end
