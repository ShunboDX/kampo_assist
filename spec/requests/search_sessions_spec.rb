require "rails_helper"

RSpec.describe "SearchSessions", type: :request do
  let(:user) { create(:user, password: "password", password_confirmation: "password") }

  def login_as(user, password: "password")
    post user_session_path, params: { email: user.email, password: password }
  end

  describe "GET /search_sessions" do
    it "redirects to login when not logged in" do
      get search_sessions_path
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "shows list when logged in" do
      login_as(user)
      get search_sessions_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /search_sessions/:id" do
    let!(:own_session) do
      user.search_sessions.create!(
        conditions: {
          "medical_area_ids" => ["1"],
          "disease_ids"      => ["2"],
          "symptom_ids"      => ["3"]
        }
      )
    end

    it "redirects to login when not logged in" do
      get search_session_path(own_session)
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "returns 404 when accessing other user's search session" do
      other = create(:user, password: "password", password_confirmation: "password")
      other_session = other.search_sessions.create!(
        conditions: { "disease_ids" => ["2"] }
      )

      login_as(user)
      get search_session_path(other_session)

      # showが current_user.search_sessions.find(...) なら 404 が自然
      expect(response).to have_http_status(:not_found)
    end
  end
end
