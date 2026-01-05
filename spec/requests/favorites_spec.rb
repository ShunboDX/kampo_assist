require "rails_helper"

RSpec.describe "Favorites", type: :request do
  let(:user)  { create(:user, password: "password", password_confirmation: "password") }
  let(:kampo) { create(:kampo) }

  def login_as(user)
    post user_session_path, params: { email: user.email, password: "password" }
  end

  describe "GET /favorites" do
    context "when not logged in" do
      it "redirects to login" do
        get favorites_path
        expect(response).to have_http_status(:found)
      end
    end

    context "when logged in" do
      it "returns http success" do
        login_as(user)
        get favorites_path
        expect(response).to have_http_status(:success)
      end

      it "shows favorited kampo" do
        login_as(user)
        user.favorites.create!(kampo: kampo)

        get favorites_path
        expect(response.body).to include(kampo.name)
      end
    end
  end

  describe "POST /kampos/:kampo_id/favorite" do
    context "when not logged in" do
      it "does not create favorite and redirects" do
        expect {
          post kampo_favorite_path(kampo)
        }.not_to change(Favorite, :count)

        expect(response).to have_http_status(:found)
      end
    end

    context "when logged in" do
      it "creates favorite" do
        login_as(user)

        expect {
          post kampo_favorite_path(kampo)
        }.to change(Favorite, :count).by(1)

        expect(response).to have_http_status(:found)
      end

      it "does not raise error when posting twice" do
        login_as(user)

        post kampo_favorite_path(kampo)
        expect { post kampo_favorite_path(kampo) }.not_to raise_error
      end
    end
  end

  describe "DELETE /kampos/:kampo_id/favorite" do
    context "when logged in" do
      it "destroys favorite" do
        login_as(user)
        user.favorites.create!(kampo: kampo)

        expect {
          delete kampo_favorite_path(kampo)
        }.to change(Favorite, :count).by(-1)

        expect(response).to have_http_status(:found)
      end

      it "does not destroy other user's favorite" do
        other_user = create(:user, password: "password", password_confirmation: "password")
        other_user.favorites.create!(kampo: kampo)

        login_as(user)

        expect {
          delete kampo_favorite_path(kampo)
        }.not_to change(Favorite, :count)
      end
    end
  end
end
