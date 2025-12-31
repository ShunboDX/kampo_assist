require "rails_helper"

RSpec.describe "Searches", type: :request do
  describe "GET /step1" do
    it "returns http success" do
      get step1_search_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /step2" do
    context "when not logged in" do
      it "redirects to login page" do
        get step2_search_path
        expect(response).to have_http_status(:found) # 302
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when logged in" do
      let(:password) { "password" }
      let(:user) { create(:user, password: password) }

      before do
        post user_session_path, params: { email: user.email, password: password }
      end

      it "returns http success" do
        get step2_search_path
        expect(response).to have_http_status(:success)
      end
    end
  end
end
