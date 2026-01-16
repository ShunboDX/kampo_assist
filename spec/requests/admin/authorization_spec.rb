require "rails_helper"

RSpec.describe "Admin authorization", type: :request do
  let(:password) { "password" }

  def login_as(user)
    post user_session_path, params: { email: user.email, password: password }
  end

  describe "GET /admin" do
    it "returns 403 when not logged in" do
      get admin_root_path
      expect(response).to have_http_status(:forbidden)
    end

    it "returns 403 when logged in as non-admin" do
      user = create(:user, password: password, password_confirmation: password, role: :user)
      login_as(user)

      get admin_root_path
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "GET /admin/kampos" do
    it "returns 403 when logged in as non-admin" do
      user = create(:user, password: password, password_confirmation: password, role: :user)
      login_as(user)

      get admin_kampos_path
      expect(response).to have_http_status(:forbidden)
    end
  end
end
