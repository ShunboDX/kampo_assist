require 'rails_helper'

RSpec.describe "Searches", type: :request do
  describe "GET /step1" do
    it "returns http success" do
      get "/searches/step1"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /step2" do
    it "returns http success" do
      get "/searches/step2"
      expect(response).to have_http_status(:success)
    end
  end
end
