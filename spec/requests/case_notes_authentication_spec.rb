# spec/requests/case_notes_authentication_spec.rb
require "rails_helper"

RSpec.describe "CaseNotes authentication", type: :request do
  it "redirects to login when not logged in (index)" do
    get case_notes_path
    expect(response).to have_http_status(:see_other).or have_http_status(:found)
    expect(response).to redirect_to(new_user_session_path)
  end

  it "redirects to login when not logged in (new)" do
    get new_case_note_path
    expect(response).to have_http_status(:see_other).or have_http_status(:found)
    expect(response).to redirect_to(new_user_session_path)
  end

  it "redirects to login when not logged in (create)" do
    post case_notes_path, params: { case_note: { body: "x" } }
    expect(response).to have_http_status(:see_other).or have_http_status(:found)
    expect(response).to redirect_to(new_user_session_path)
  end
end
