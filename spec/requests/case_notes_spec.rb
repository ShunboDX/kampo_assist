require "rails_helper"

RSpec.describe "CaseNotes", type: :request do
  let(:user) do
    create(:user, password: "password", password_confirmation: "password")
  end
  let(:other_user) do
    create(:user, password: "password", password_confirmation: "password")
  end

  def login_as(user)
    post user_session_path, params: { email: user.email, password: "password" }
  end

  describe "GET /case_notes" do
    it "redirects when not logged in" do
      get case_notes_path
      expect(response).to have_http_status(:found)
    end

    it "shows only current_user notes" do
      login_as(user)
      my_note = user.case_notes.create!(body: "mine")
      other_user.case_notes.create!(body: "others")

      get case_notes_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("mine")
      expect(response.body).not_to include("others")
    end
  end

  describe "POST /case_notes" do
    it "creates a note for current_user" do
      login_as(user)

      expect do
        post case_notes_path, params: { case_note: { body: "hello" } }
      end.to change(CaseNote, :count).by(1)

      note = CaseNote.order(:id).last
      expect(note.user_id).to eq(user.id)
      expect(note.body).to eq("hello")
      expect(response).to have_http_status(:found)
    end

    it "does not allow spoofing user_id" do
      login_as(user)

      post case_notes_path, params: {
        case_note: { body: "hack", user_id: other_user.id }
      }

      note = CaseNote.order(:id).last
      expect(note.user_id).to eq(user.id) # current_userに固定されていること
    end
  end

  describe "PATCH /case_notes/:id" do
    it "updates own note" do
      login_as(user)
      note = user.case_notes.create!(body: "before")

      patch case_note_path(note), params: { case_note: { body: "after" } }
      expect(response).to have_http_status(:found)
      expect(note.reload.body).to eq("after")
    end

    it "cannot update other user's note (404)" do
      login_as(user)
      other_note = other_user.case_notes.create!(body: "nope")

      patch case_note_path(other_note), params: { case_note: { body: "hacked" } }
      expect(response).to have_http_status(:not_found)
      expect(other_note.reload.body).to eq("nope")
    end
  end

  describe "DELETE /case_notes/:id" do
    it "deletes own note" do
      login_as(user)
      note = user.case_notes.create!(body: "bye")

      expect do
        delete case_note_path(note)
      end.to change(CaseNote, :count).by(-1)

      expect(response).to have_http_status(:found)
    end

    it "cannot delete other user's note (404)" do
      login_as(user)
      other_note = other_user.case_notes.create!(body: "stay")

      expect do
        delete case_note_path(other_note)
      end.not_to change(CaseNote, :count)

      expect(response).to have_http_status(:not_found)
      expect(other_note.reload).to be_present
    end
  end
end
