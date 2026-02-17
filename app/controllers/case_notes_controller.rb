class CaseNotesController < ApplicationController
  before_action :require_login
  before_action :set_case_note, only: [ :edit, :update, :destroy ]

  def index
    @case_notes = current_user.case_notes.order(created_at: :desc)
  end

  def new
    @case_note = current_user.case_notes.build(
        kampo_id: params[:kampo_id],
        search_session_id: params[:search_session_id]
    )
  end

  def create
    Rails.logger.debug "[CaseNotes#create] format=#{request.format} accept=#{request.headers['ACCEPT']}"
    @case_note = current_user.case_notes.build(case_note_params)

    if @case_note.save
      respond_to do |format|
        format.html { redirect_to case_notes_path, notice: "症例メモを作成しました" }
        format.turbo_stream { redirect_to case_notes_path, notice: "症例メモを作成しました" }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @case_note.update(case_note_params)
      redirect_to(safe_return_to || case_notes_path, notice: "症例メモを更新しました")
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
   @case_note = current_user.case_notes.find(params[:id])
  end

  def case_note_params
    params.require(:case_note).permit(:body, :kampo_id, :search_session_id)
  end

  def safe_return_to
    rt = params[:return_to].to_s
    rt.start_with?("/") ? rt : nil
  end
end
