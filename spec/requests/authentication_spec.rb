# spec/requests/authentication_spec.rb
require "rails_helper"

RSpec.describe "Authentication (login required pages)", type: :request do
  shared_examples "redirects to login" do
    it "redirects to login when not logged in" do
      subject
      expect(response).to have_http_status(:see_other).or have_http_status(:found)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  # --- Favorites ---
  describe "GET /favorites" do
    subject { get favorites_path }
    it_behaves_like "redirects to login"
  end

  # --- SearchSessions ---
  describe "GET /search_sessions" do
    subject { get search_sessions_path }
    it_behaves_like "redirects to login"
  end

  # --- CaseNotes ---
  describe "GET /case_notes" do
    subject { get case_notes_path }
    it_behaves_like "redirects to login"
  end

  describe "GET /case_notes/new" do
    subject { get new_case_note_path }
    it_behaves_like "redirects to login"
  end

  describe "POST /case_notes" do
    subject { post case_notes_path, params: { case_note: { body: "test" } } }
    it_behaves_like "redirects to login"
  end

  # edit はIDが必要なのでダミーでOK（未ログインなら find まで行かない）
  describe "GET /case_notes/:id/edit" do
    subject { get edit_case_note_path(1) }
    it_behaves_like "redirects to login"
  end

  describe "PATCH /case_notes/:id" do
    subject { patch case_note_path(1), params: { case_note: { body: "update" } } }
    it_behaves_like "redirects to login"
  end

  describe "DELETE /case_notes/:id" do
    subject { delete case_note_path(1) }
    it_behaves_like "redirects to login"
  end
end
