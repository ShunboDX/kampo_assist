class CaseNotesController < ApplicationController
  before_action :require_login

  def index
    @case_notes = current_user.case_notes.order(created_at: :desc)
  end
end
