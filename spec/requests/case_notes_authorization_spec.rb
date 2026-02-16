# spec/requests/case_notes_authorization_spec.rb
require "rails_helper"

RSpec.describe "CaseNotes authorization (owner only)", type: :request do
  let(:user)       { create(:user, password: "password", password_confirmation: "password") }
  let(:other_user) { create(:user, password: "password", password_confirmation: "password") }

  def login_as(u)
    post user_session_path, params: { email: u.email, password: "password" }
  end

  it "returns 404 when trying to edit other user's case_note" do
    other_note = other_user.case_notes.create!(body: "secret")

    login_as(user)
    get edit_case_note_path(other_note)

    expect(response).to have_http_status(:not_found)
  end

  it "returns 404 when trying to update other user's case_note" do
    other_note = other_user.case_notes.create!(body: "secret")

    login_as(user)
    patch case_note_path(other_note), params: { case_note: { body: "hacked" } }

    expect(response).to have_http_status(:not_found)
  end

  it "returns 404 when trying to delete other user's case_note" do
    other_note = other_user.case_notes.create!(body: "secret")

    login_as(user)
    delete case_note_path(other_note)

    expect(response).to have_http_status(:not_found)
  end
end
