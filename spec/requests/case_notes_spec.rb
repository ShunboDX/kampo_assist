require "rails_helper"

RSpec.describe "CaseNotes", type: :request do
  let(:user)       { create(:user, password: "password", password_confirmation: "password") }
  let(:other_user) { create(:user, password: "password", password_confirmation: "password") }

  # CaseNoteが参照する前提のデータ（必須になっている可能性が高い）
  let(:kampo) { create(:kampo) }

  def login_as(user)
    post user_session_path, params: { email: user.email, password: "password" }
  end

  def create_search_session(for_user)
    for_user.search_sessions.create!(
      conditions: { "disease_ids" => [], "symptom_ids" => [] }
    )
  end

  def create_case_note(for_user, body:)
    ss = create_search_session(for_user)
    for_user.case_notes.create!(body: body, kampo_id: kampo.id, search_session_id: ss.id)
  end

  describe "GET /case_notes" do
    it "redirects when not logged in" do
      get case_notes_path
      expect(response).to have_http_status(:found)
    end

    it "shows only current_user notes" do
      login_as(user)
      create_case_note(user, body: "mine")
      create_case_note(other_user, body: "others")

      get case_notes_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("mine")
      expect(response.body).not_to include("others")
    end
  end

  describe "POST /case_notes" do
    it "creates a note for current_user" do
      login_as(user)
      ss = create_search_session(user)

      expect do
        post case_notes_path,
            params: {
              case_note: {
                body: "hello world " * 5,
                kampo_id: kampo.id,
                search_session_id: ss.id
              }
            },
            headers: { "ACCEPT" => "text/html" }
      end.to change(CaseNote, :count).by(1)

      note = CaseNote.find_by!(user_id: user.id, body: "hello world " * 5)
      expect(note.body).to eq("hello world " * 5)
      expect(response).to have_http_status(:found)
    end

    it "does not allow spoofing user_id" do
      login_as(user)
      ss = create_search_session(user)

      expect do
        post case_notes_path,
            params: {
              case_note: {
                body: "hack!! " * 10,
                user_id: other_user.id,
                kampo_id: kampo.id,
                search_session_id: ss.id
              }
            },
            headers: { "ACCEPT" => "text/html" }
      end.to change(CaseNote, :count).by(1)

      note = CaseNote.find_by!(body: "hack!! " * 10)
      expect(note.user_id).to eq(user.id)
    end
  end

  describe "PATCH /case_notes/:id" do
    it "updates own note" do
      login_as(user)
      note = create_case_note(user, body: "before")

      patch case_note_path(note), params: { case_note: { body: "after" } }
      expect(response).to have_http_status(:found)
      expect(note.reload.body).to eq("after")
    end

    it "cannot update other user's note (404)" do
      login_as(user)
      other_note = create_case_note(other_user, body: "nope")

      patch case_note_path(other_note), params: { case_note: { body: "hacked" } }
      expect(response).to have_http_status(:not_found)
      expect(other_note.reload.body).to eq("nope")
    end
  end

  describe "DELETE /case_notes/:id" do
    it "deletes own note" do
      login_as(user)
      note = create_case_note(user, body: "bye")

      expect do
        delete case_note_path(note)
      end.to change(CaseNote, :count).by(-1)

      expect(response).to have_http_status(:found)
    end

    it "cannot delete other user's note (404)" do
      login_as(user)
      other_note = create_case_note(other_user, body: "stay")

      expect do
        delete case_note_path(other_note)
      end.not_to change(CaseNote, :count)

      expect(response).to have_http_status(:not_found)
      expect(other_note.reload).to be_present
    end
  end
end
